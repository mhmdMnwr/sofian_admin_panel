import React, { useState, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import { MainLayout } from '../../components/layout';
import { MapContainer, TileLayer, Marker, useMapEvents } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import L from 'leaflet';
import apiClient from '../../core/api/apiClient';
import './InformationPage.css';

// Fix for default Leaflet markers in React
delete (L.Icon.Default.prototype as any)._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
  iconUrl: require('leaflet/dist/images/marker-icon.png'),
  shadowUrl: require('leaflet/dist/images/marker-shadow.png'),
});

interface SettingsData {
  shopPhone: string;
  shopLatitude: number | null;
  shopLongitude: number | null;
}

const LocationMarker = ({ position, setPosition }: { position: L.LatLng | null, setPosition: (p: L.LatLng) => void }) => {
  useMapEvents({
    click(e) {
      setPosition(e.latlng);
    },
  });

  return position === null ? null : (
    <Marker position={position} />
  );
};

const InformationPage: React.FC = () => {
  const { t } = useTranslation();
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  
  const [formData, setFormData] = useState<SettingsData>({
    shopPhone: '',
    shopLatitude: null,
    shopLongitude: null,
  });

  const [mapPosition, setMapPosition] = useState<L.LatLng | null>(null);

  // Default center (e.g., Algiers, Algeria if nothing is set)
  const defaultCenter: [number, number] = [36.7538, 3.0588];

  useEffect(() => {
    const fetchSettings = async () => {
      setLoading(true);
      setError(null);
      try {
        const response = await apiClient.get('/settings');
        if (response.data.status === 'success') {
          const data = response.data.data;
          setFormData({
            shopPhone: data.shopPhone || '',
            shopLatitude: data.shopLatitude || null,
            shopLongitude: data.shopLongitude || null,
          });
          if (data.shopLatitude && data.shopLongitude) {
            setMapPosition(new L.LatLng(data.shopLatitude, data.shopLongitude));
          }
        }
      } catch (error) {
        console.error('Failed to load settings:', error);
        setError(t('information.loadError', 'Failed to load shop information.'));
      } finally {
        setLoading(false);
      }
    };
    fetchSettings();
  }, [t]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleMapClick = (latlng: L.LatLng) => {
    setMapPosition(latlng);
    setFormData((prev) => ({
      ...prev,
      shopLatitude: latlng.lat,
      shopLongitude: latlng.lng,
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    setError(null);
    setSuccess(null);
    try {
      const response = await apiClient.patch('/settings/updateShopInfo', formData);
      if (response.data.status === 'success') {
        setSuccess(t('information.saveSuccess', 'Shop information updated successfully!'));
      } else {
        setError(response.data.message || t('errors.unknownError', 'Failed to update'));
      }
    } catch (error: any) {
      console.error('Failed to update shop info:', error);
      setError(error.response?.data?.message || t('information.saveError', 'An error occurred while saving.'));
    } finally {
      setSaving(false);
    }
  };

  return (
    <MainLayout>
      <div className="information-page">
        <div className="information-page__header">
          <div className="information-page__header-left">
            <h1 className="information-page__title">{t('information.title', 'Shop Information')}</h1>
            <p className="information-page__subtitle">{t('information.subtitle', 'Update the shop public contact and location details.')}</p>
          </div>
        </div>

        <div className="information-page__content">
          {error && <div className="error-message" style={{ color: '#dc2626', marginBottom: '16px', fontWeight: 500 }}>{error}</div>}
          {success && <div className="success-message" style={{ color: '#059669', marginBottom: '16px', fontWeight: 500 }}>{success}</div>}

          {loading ? (
            <div className="loading-spinner-wrapper">
              <div className="loading-spinner"></div>
            </div>
          ) : (
            <form className="information-page__form" onSubmit={handleSubmit}>
              <div className="form-group">
                <label htmlFor="shopPhone">{t('information.phone', 'Shop Phone Number')}</label>
                <input
                  type="tel"
                  id="shopPhone"
                  name="shopPhone"
                  className="form-input"
                  value={formData.shopPhone}
                  onChange={handleChange}
                  placeholder="05 XX XX XX XX"
                />
              </div>

              <div className="form-group">
                <label>{t('information.location', 'Map Location (Click to set marker)')}</label>
                <div className="map-container-wrapper">
                  <MapContainer 
                    center={mapPosition || defaultCenter} 
                    zoom={mapPosition ? 13 : 5} 
                    className="map-container"
                  >
                    <TileLayer
                      attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                      url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                    />
                    <LocationMarker position={mapPosition} setPosition={handleMapClick} />
                  </MapContainer>
                </div>
              </div>

              <div className="form-actions">
                <button type="submit" className="btn-submit" disabled={saving}>
                  {saving ? t('common.saving', 'Saving...') : t('common.saveChanges', 'Save Changes')}
                </button>
              </div>
            </form>
          )}
        </div>
      </div>
    </MainLayout>
  );
};

export default InformationPage;
