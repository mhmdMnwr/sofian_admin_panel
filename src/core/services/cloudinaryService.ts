/**
 * Cloudinary Upload Service
 * Handles image uploads to Cloudinary with folder organization
 */

const CLOUD_NAME = process.env.REACT_APP_CLOUDINARY_CLOUD_NAME;
const UPLOAD_PRESET = process.env.REACT_APP_CLOUDINARY_UPLOAD_PRESET;
const CLOUDINARY_URL = `https://api.cloudinary.com/v1_1/${CLOUD_NAME}/image/upload`;

export type CloudinaryFolder = 'products' | 'brands' | 'categories';

export interface CloudinaryUploadResponse {
  secure_url: string;
  public_id: string;
  width: number;
  height: number;
  format: string;
  bytes: number;
}

export interface UploadResult {
  success: boolean;
  url?: string;
  publicId?: string;
  error?: string;
}

/**
 * Upload an image to Cloudinary
 * @param file - The image file to upload
 * @param folder - The folder to organize images (products, brands, categories)
 * @returns Promise with the upload result containing the secure URL
 */
export const uploadToCloudinary = async (
  file: File,
  folder: CloudinaryFolder
): Promise<UploadResult> => {
  if (!CLOUD_NAME || !UPLOAD_PRESET) {
    console.error('Cloudinary configuration missing');
    return {
      success: false,
      error: 'Cloudinary configuration is missing. Please check environment variables.',
    };
  }

  try {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('upload_preset', UPLOAD_PRESET);
    formData.append('folder', `sofiane_shop_images/${folder}`);
    
    const response = await fetch(CLOUDINARY_URL, {
      method: 'POST',
      body: formData,
    });

    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.error?.message || 'Upload failed');
    }

    const data: CloudinaryUploadResponse = await response.json();

    return {
      success: true,
      url: data.secure_url,
      publicId: data.public_id,
    };
  } catch (error) {
    console.error('Cloudinary upload error:', error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Failed to upload image',
    };
  }
};

/**
 * Get optimized Cloudinary URL with transformations
 * Applies auto format and quality for free tier optimization
 * @param url - The original Cloudinary URL
 * @param options - Transformation options
 * @returns Optimized URL
 */
export const getOptimizedImageUrl = (
  url: string,
  options?: {
    width?: number;
    height?: number;
    crop?: 'fill' | 'fit' | 'scale' | 'thumb';
  }
): string => {
  if (!url || !url.includes('cloudinary.com')) {
    return url;
  }

  // Build transformation string
  const transformations = ['f_auto', 'q_auto'];
  
  if (options?.width) {
    transformations.push(`w_${options.width}`);
  }
  if (options?.height) {
    transformations.push(`h_${options.height}`);
  }
  if (options?.crop) {
    transformations.push(`c_${options.crop}`);
  }

  const transformString = transformations.join(',');

  // Insert transformations into URL
  // Cloudinary URL format: https://res.cloudinary.com/{cloud}/image/upload/{transformations}/{path}
  const uploadIndex = url.indexOf('/upload/');
  if (uploadIndex === -1) {
    return url;
  }

  const beforeUpload = url.substring(0, uploadIndex + 8); // includes '/upload/'
  const afterUpload = url.substring(uploadIndex + 8);

  return `${beforeUpload}${transformString}/${afterUpload}`;
};

export default {
  uploadToCloudinary,
  getOptimizedImageUrl,
};
