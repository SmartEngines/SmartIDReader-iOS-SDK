/*
Copyright (c) 2012-2017, Smart Engines Ltd
All rights reserved.
*/

/**
 * @file smartid_common.h
 * @brief Common classes used in SmartIdEngine
 */

#ifndef SMARTID_ENGINE_SMARTID_COMMON_H_INCLUDED_
#define SMARTID_ENGINE_SMARTID_COMMON_H_INCLUDED_

#if defined _MSC_VER
#pragma warning(push)  
#pragma warning(disable : 4290)  
#endif

#if defined _WIN32 && SMARTID_ENGINE_EXPORTS
#define SMARTID_DLL_EXPORT __declspec(dllexport)
#else
#define SMARTID_DLL_EXPORT
#endif

#include <stdexcept>

namespace se { namespace smartid {

/**
 * @brief Class for representing a rectangle on an image
 */
class SMARTID_DLL_EXPORT Rectangle {
public:
  /**
   * @brief Constructor (x = y = width = height = 0)
   */
  Rectangle();

  /**
   * @brief Constructor from coordinates
   * @param x      - Top-left rectangle point x-coordinate in pixels
   * @param y      - Top-left rectangle point y-coordinate in pixels
   * @param width  - Rectangle width in pixels
   * @param height - Rectangle height in pixels
   */
  Rectangle(int x, int y, int width, int height);

public:
  int x;      ///< x-coordinate of a top-left point in pixels
  int y;      ///< r-coordinate of a top-left point in pixels
  int width;  ///< rectangle width in pixels
  int height; ///< rectangle height in pixels
};

/**
 * @brief Class for representing a point on an image
 */
class SMARTID_DLL_EXPORT Point {
public:
  /**
   * @brief Default Constructor (x = y = 0)
   */
  Point();

  /**
   * @brief  Constructor
   * @param  x - x-coordinate of a point in pixels (top-left corner is origin)
   * @param  y - y-coordinate of a point in pixels (top-left corner is origin)
   */
  Point(double x, double y);

  double x; ///< x-coordinate in pixels (top-left corner is origin)
  double y; ///< y-coordinate in pixels (top-left corner is origin)
};

/**
 * @brief Class for representing a quadrangle on an image
 */
class SMARTID_DLL_EXPORT Quadrangle {
public:
  /**
   * @brief  Constructor
   */
  Quadrangle();

  /**
   * @brief  Constructor
   * @param  a Top-left vertex of the quadrangle
   * @param  b Top-right vertex of the quadrangle
   * @param  c Bottom-right vertex of the quadrangle
   * @param  d Bottom-left vertex of the quadrangle
   */
  Quadrangle(Point a, Point b, Point c, Point d);

  /**
   * @brief  Returns the quadrangle vertex at the given @p index as a modifiable
   * reference
   * @param  index Index position for quadrangle vertex, from 0 till 3
   *
   * @throws std::out_of_range if index is not in range [0 ... 3]
   */
  Point& operator[](int index) throw(std::exception);

  /**
   * @brief  Returns the quadrangle vertex at the given @p index as a constant
   * reference
   * @param  index Index position for quadrangle vertex, from 0 till 3
   *
   * @throws std::out_of_range if index is not in range [0 ... 3]
   */
  const Point& operator[](int index) const throw(std::exception);

  /**
   * @brief  Returns the quadrangle vertex at the given @p index as a constant
   * reference
   * @param  index Index position for quadrangle vertex, from 0 till 3
   *
   * @throws std::out_of_range if index is not in range [0 ... 3]
   */
  const Point& GetPoint(int index) const throw(std::exception);

  /**
   * @brief  Sets the quadrangle vertex at the given @p index to specified @p
   * value
   * @param  index Index position for quadrangle vertex, from 0 till 3
   * @param  value New value for quadrangle vertex
   *
   * @throws std::out_of_range if index is not in range [0 ... 3]
   */
  void SetPoint(int index, const Point& value) throw(std::exception);

public:
  /// Vector of quadrangle vertices in order:
  ///     top-left, top-right, bottom-right, bottom-left
  Point points[4];
};

/**
 * @brief Class for representing a bitmap image
 */
class SMARTID_DLL_EXPORT Image {
public:
  /// Default ctor, creates null image with no memory owning
  Image();

  /**
   * @brief smartid::Image ctor from image file
   * @param image_filename - path to an image. Supported formats: png, jpg, tif
   *
   * @throw std::runtime_error if image loading failed
   */
  Image(const std::string& image_filename) throw(std::exception);

  /**
   * @brief smartid::Image ctor from raw buffer
   * @param data - pointer to a buffer start
   * @param data_length - length of the buffer
   * @param width - width of the image
   * @param height - height of the image
   * @param stride - address difference between two vertically adjacent pixels
   *        in bytes
   * @param channels - number of image channels (1-grayscale, 3-RGB, 4-BGRA)
   *
   * @details resulting image is a memory-owning copy
   *
   * @throw std::runtime_error if image creating failed
   */
  Image(unsigned char* data, size_t data_length, int width, int height,
        int stride, int channels) throw(std::exception);

  /**
   * @brief  smartid::Image ctor from YUV buffer
   * @param  yuv_data - Pointer to the data buffer start
   * @param  yuv_data_length - Total length of image data buffer
   * @param  width - Image width
   * @param  height - Image height
   *
   * @throws std::exception if image creating failed
   */
  Image(unsigned char* yuv_data, size_t yuv_data_length,
        int width, int height) throw(std::exception);

  /**
   * @brief smartid::Image copy ctor
   * @param copy - an image to copy from. If 'copy' doesn't own memory then only
   *        the reference is copied. If 'copy' owns image memory then new image
   *        will be allocated with the same data as 'copy'.
   */
  Image(const Image& copy);

  /**
   * @brief smartid::Image assignment operator
   * @param other - an image to assign. If 'other' doesn't own memory then only
   *        the reference is assigned. If 'other' owns image memory then new
   *        image will be allocated with the same data as 'other'.
   */
  Image& operator=(const Image& other);

  /// Image dtor
  ~Image();

  /**
   * @brief Saves an image to file
   * @param image_filename - path to an image. Supported formats: png, jpg, tif,
   *        format is deduced from the filename extension
   *
   * @throw std::runtime_error if image saving failed
   */
  void Save(const std::string& image_filename) const throw(std::exception);

  /**
   * @brief Returns required buffer size for copying image data, O(1)
   * @return Buffer size in bytes
   */
  int GetRequiredBufferLength() const;

  /**
   * @brief Copies the image data to specified buffer
   * @param out_buffer     Destination buffer, must be preallocated
   * @param buffer_length  Size of buffer @p out_buffer
   * @return Number of bytes copied
   *
   * @throw std::invalid_argument if buffer size (buffer_length) is not enough
   *        to store the image, or if out_buffer is NULL
   *        std::runtime_error if unexpected error happened in the copying
   * process
   */
  int CopyToBuffer(
      char* out_buffer, int buffer_length) const throw(std::exception);

  /**
   * @brief Returns required buffer size for Base64 JPEG representation of an
   * image. WARNING: will perform one extra JPEG coding of an image
   * @return Buffer size in bytes
   *
   * @throws std::runtime_error if failed to calculate the necessary buffer size
   */
  int GetRequiredBase64BufferLength() const throw(std::exception);

  /**
   * @brief Copy JPEG representation of the image to buffer (in base64 coding).
   *        The buffer must be large enough.
   * @param out_buffer     Destination buffer, must be preallocated
   * @param buffer_length  Size of buffer @p out_buffer
   * @return Number of bytes copied
   *
   * @throw std::invalid_argument if buffer size (buffer_length) is not enough
   * to store the image, or if out_buffer is NULL.
   * std::runtime_error if unexpected error happened in the copying process
   */
  int CopyBase64ToBuffer(
      char* out_buffer, int buffer_length) const throw(std::exception);

  /**
   * @brief Clears the internal image structure, deallocates memory if owns it
   */
  void Clear();

  /**
   * @brief Getter for image width
   * @return Image width in pixels
   */
  int GetWidth() const;

  /**
   * @brief Getter for image height
   * @return Image height in pixels
   */
  int GetHeight() const;

  /**
   * @brief Getter for number of image channels
   * @return Image number of channels
   */
  int GetChannels() const;

  /**
   * @brief Returns whether this instance owns (and will release) image data
   * @return memown variable value
   */
  bool IsMemoryOwner() const;

  /**
   * @brief Forces memory ownership - allocates new image data and sets
   * memown to true if memown was false, otherwise does nothing
   */
  void ForceMemoryOwner();

  /**
   * @brief Scale (resize) this image to new width and height, force memory ownership
   * @param new_width New image width
   * @param new_height New image height
   */
  void Resize(int new_width, int new_height);

public:
  char* data;   ///< Pointer to the first pixel of the first row
  int width;    ///< Width of the image in pixels
  int height;   ///< Height of the image in pixels
  int stride;   ///< Difference in bytes between addresses of adjacent rows
  int channels; ///< Number of image channels
  bool memown;  ///< Whether the image owns the memory itself
};

/**
 * @brief The ImageOrientation enum
 */
enum SMARTID_DLL_EXPORT ImageOrientation {
  Landscape, ///< image is in the proper orientation, nothing needs to be done
  Portrait,  ///< image is in portrait, needs to be rotated 90° clockwise
  InvertedLandscape, ///< image is upside-down, needs to be rotated 180°
  InvertedPortrait   ///< image is in portrait, needs to be rotated 90°
                     ///counter-clockwise
};

} } // namespace se::smartid

#if defined _MSC_VER
#pragma warning(pop)  
#endif

#endif // SMARTID_ENGINE_SMARTID_COMMON_H_INCLUDED
