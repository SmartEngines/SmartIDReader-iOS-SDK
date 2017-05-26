/**
 * Copyright (c) 2012-2017, Smart Engines Ltd
 * All rights reserved.
 */

/**
 * @file smartid_result.h
 * @brief Recognition result classes
 */

#ifndef SMARTID_ENGINE_SMARTID_RESULT_H_INCLUDED_
#define SMARTID_ENGINE_SMARTID_RESULT_H_INCLUDED_

#if defined _MSC_VER
#pragma warning(push)  
#pragma warning(disable : 4290)  
#endif

#include "smartid_common.h"

#include <cstdint>
#include <map>
#include <string>
#include <vector>

namespace se { namespace smartid {

/**
 * @brief Possible character recognition result
 */
class SMARTID_DLL_EXPORT OcrCharVariant {
public:
  /**
   * @brief Default ctor
   */
  OcrCharVariant();

  /// OcrCharVariant dtor
  ~OcrCharVariant() {}

  /**
   * @brief Ctor from utf16 character and confidence
   * @param utf16_char - Utf16-character of a symbol
   * @param confidence - double confidence in range [0..1]
   *
   * @throw std::invalid_argument if confidence is not in range [0..1]
   */
  OcrCharVariant(uint16_t utf16_char, double confidence) throw(std::exception);

  /**
   * @brief Ctor from utf8 character and confidence
   * @param utf8_char - utf8-representation of a 2-byte symbol in std::string
   * form
   * @param confidence - double confidence in range [0..1]
   *
   * @throw std::invalid_argument if confidence is not in range [0..1] or
   *        if utf8_char is not a correct utf8 representation of 2-byte symbol
   */
  OcrCharVariant(const std::string& utf8_char,
                 double confidence) throw(std::exception);

  /// Getter for character in Utf16 form
  uint16_t GetUtf16Character() const;
  /// Getter for character in Utf8 form
  std::string GetUtf8Character() const;
  /// Variant confidence (pseudoprobability), in range [0..1]
  double GetConfidence() const;

private:
  uint16_t character_;
  double confidence_;
};

/**
 * @brief Contains all OCR information for a given character
 */
class SMARTID_DLL_EXPORT OcrChar {
public:
  /**
   * @brief Default ctor
   */
  OcrChar();

  /**
   * @brief Main ctor
   * @param ocr_char_variants - vector of char variants
   * @param is_highlighted - whether this OcrChar is highlighted as unconfident
   * @param is_corrected - whether this OcrChar was corrected by post-processing
   */
  OcrChar(const std::vector<OcrCharVariant>& ocr_char_variants,
          bool is_highlighted, bool is_corrected);

  /// OcrChar dtor
  ~OcrChar() {}

  /// Vector with possible recognition results for a given character
  const std::vector<OcrCharVariant>& GetOcrCharVariants() const;

  /// Whether this character is 'highlighted' (not confident) by the system
  bool IsHighlighted() const;
  /// Whether this character was changed by context correction (postprocessing)
  bool IsCorrected() const;

  /**
   * @brief Returns the most confident character as 16-bit utf16 character
   *
   * @throws std::out_of_range if variants are empty
   */
  uint16_t GetUtf16Character() const throw(std::exception);

  /**
   * @brief Returns the most confident character as utf8 representation of
   * 16-bit character
   *
   * @throws std::out_of_range if variants are empty
   */
  std::string GetUtf8Character() const throw(std::exception);

private:
  std::vector<OcrCharVariant> ocr_char_variants_;
  bool is_highlighted_;
  bool is_corrected_;
};

/**
 * @brief Contains additional OCR information for the whole string
 */
class SMARTID_DLL_EXPORT OcrString {
public:
  /// Default ctor
  OcrString();
  /// Ctor from vector of OcrChars
  OcrString(const std::vector<OcrChar>& ocr_chars);
  /**
   * @brief OcrString ctor from plain utf8 string
   */
  OcrString(const std::string& utf8_string);
  /// OcrString dtor
  ~OcrString() {}

  /// Vector with OCR information for each character
  const std::vector<OcrChar>& GetOcrChars() const;

  /// Returns the most-confident string representation
  std::string GetUtf8String() const;

  /// Returns the most-confident string representation
  std::vector<uint16_t> GetUtf16String() const;

private:
  std::vector<OcrChar> ocr_chars_;
};

/**
 * @brief Class represents implementation of SmartID document Field for string
 * fields
 */
class SMARTID_DLL_EXPORT StringField {
public:
  /**
   * @brief Default constructor
   */
  StringField();

  /**
   * @brief StringField main ctor
   * @param name - name of the field
   * @param value - OcrString-representation of the field value
   * @param is_accepted - whether the system is confident in the field's value
   * @param confidence - system's confidence level in fields' value in range
   * [0..1]
   *
   * @throws std::invalid_argument if confidence value is not in range [0..1]
   */
  StringField(const std::string& name, const OcrString& value, bool is_accepted,
              double confidence) throw(std::exception);

  /**
   * @brief StringField ctor from utf8-string value
   * @param name - name of the field
   * @param value - utf8-string representation of the field value
   * @param is_accepted - whether the system is confident in the field's value
   * @param confidence - system's confidence level in fields' value in range
   * [0..1]
   *
   * @throws std::invalid_argument if confidence value is not in range [0..1] or
   *         if failed to decode utf8-string 'value'
   */
  StringField(const std::string& name, const std::string& value,
              bool is_accepted, double confidence) throw(std::exception);

  /**
  * @brief StringField ctor from utf8-string value (with raw value)
  * @param name - name of the field
  * @param value - utf8-string representation of the field value
  * @param raw_value - utf8-string representation of the field raw value
  * @param is_accepted - whether the system is confident in the field's value
  * @param confidence - system's confidence level in fields' value in range
  * [0..1]
  *
  * @throws std::invalid_argument if confidence value is not in range [0..1] or
  *         if failed to decode utf8-string 'value'
  */
  StringField(const std::string& name, const std::string& value, 
    const std::string& raw_value, bool is_accepted, double confidence) 
    throw(std::exception);

  /// Getter for string field name
  const std::string& GetName() const;
  /// Getter for string field value (OcrString representation)
  const OcrString& GetValue() const;
  /// Getter for string field value (Utf8-string representation)
  std::string GetUtf8Value() const;
  /// Getter for string field raw(without postprocessing) value (OcrString representation)
  const OcrString& GetRawValue() const;
  /// Getter for string field raw(without postprocessing) value (Utf8-string representation)
  std::string GetUtf8RawValue() const;
  /// Whether the system is confidence in field recognition result
  bool IsAccepted() const;
  /// The system's confidence level in field recognition result (in range
  /// [0..1])
  double GetConfidence() const;

private:
  std::string name_; ///< Field name
  OcrString value_;  ///< Fields' OcrString value
  OcrString raw_value_; ///< Fields' OcrString raw value(without postprocessing)

  /// Specifies whether the system is confident in field recognition result
  bool is_accepted_;
  /// Specifies the system's confidence level in field recognition result
  double confidence_;
};

/**
 * @brief Class represents implementation of SmartIDField for list of images
 */
class SMARTID_DLL_EXPORT ImageField {
public:
  /**
   * @brief ImageField Default ctor
   */
  ImageField();

  /**
   * @brief ImageField main ctor
   * @param name - name of the field
   * @param value - image (the field result)
   * @param is_accepted - whether the system is confident in the field's value
   * @param confidence - system's confidence level in fields' value in range
   * [0..1]
   *
   * @throws std::invalid_argument if confidence value is not in range [0..1] or
   *         if failed to decode utf8-string 'value'
   */
  ImageField(const std::string& name, const Image& value, bool is_accepted,
             double confidence) throw(std::exception);

  /// Default dtor
  ~ImageField() {}

  /// Getter for image field name
  const std::string& GetName() const;
  /// Getter for image field result
  const Image& GetValue() const;
  /// Whether the system is confidence in field result
  bool IsAccepted() const;
  /// The system's confidence level in field result (in range [0..1])
  double GetConfidence() const;

private:
  std::string name_;
  Image value_;

  bool is_accepted_;  ///< Specifies whether the system is confident in result
  double confidence_; ///< Specifies the system's confidence level in result
};

/**
 * @brief Class represents SmartID match result
 */
class SMARTID_DLL_EXPORT MatchResult {
public:
  /**
   * @brief Default ctor
   */
  MatchResult();

  /**
   * @brief MatchResult main ctor
   * @param tpl_type - template type for this match result
   * @param quadrangle - quadrangle of a template on image
   * @param accepted - acceptance for visualization
   */
  MatchResult(const std::string& tpl_type,
              const Quadrangle& quadrangle,
              bool accepted = false);

  /// Default dtor
  ~MatchResult() {}

  /// Getter for document type string
  const std::string& GetTemplateType() const;
  /// Getter for document quadrangle
  const Quadrangle& GetQuadrangle() const;
  /// Getter for acceptance field
  bool GetAccepted() const;

public:
  std::string template_type_; ///< Template type for this match result
  Quadrangle quadrangle_; ///< Quadrangle for this template
  bool accepted_; ///< Whether this result is ready to be visualized
};

/**
 * @brief Class represents SmartID segmentation result containing
 * found zones/fields location information
 */
class SMARTID_DLL_EXPORT SegmentationResult {
public:
  /// Default constructor
  SegmentationResult();

  /// Main constructor
  SegmentationResult(const std::map<std::string, Quadrangle>& zone_quadrangles,
                     bool accepted = false);

  /// Destructor
  ~SegmentationResult();

  /// Getter for zone names which are keys for ZoneQuadrangles map
  std::vector<std::string> GetZoneNames() const;

  /// Checks if there is a zone quadrangle with given zone_name
  bool HasZoneQuadrangle(const std::string &zone_name) const;

  /**
   * @brief Get zone quadrangle for zone name
   * @param zone_name zone name
   * @return Zone quadrangle for zone name
   * @throws std::invalid_argument if zone_name is not present in zone quadrangles
   */
  const Quadrangle& GetZoneQuadrangle(const std::string &zone_name) const throw (std::exception);

  /// Getter for zone quadrangles (zone name -> quadrangle]
  const std::map<std::string, Quadrangle>& GetZoneQuadrangles() const;

  /**
   * @brief Gets field name corresponding to this zone
   * @param zone_name zone name
   * @return Field name for this zone, could be the same as zone_name
   * @throws std::invalid_argument if zone_name is not present in zone quadrangles
   */
  std::string GetZoneFieldName(const std::string &zone_name) const throw (std::exception);

  /// Getter for accepted field
  bool GetAccepted() const;

private:
  std::map<std::string, Quadrangle> zone_quadrangles_; ///< [zone name, quadrangle]
  bool accepted_; ///< Whether this result is ready to be visualized
};

/**
 * @brief Class represents SmartID recognition result
 */
class SMARTID_DLL_EXPORT RecognitionResult {
public:
  /**
   * @brief Default ctor
   */
  RecognitionResult();

  /**
   * @brief RecognitionResult main ctor
   */
  RecognitionResult(const std::map<std::string, StringField>& string_fields,
                    const std::map<std::string, ImageField>& image_fields,
                    const std::string& document_type,
                    const std::vector<MatchResult>& match_results,
                    const std::vector<SegmentationResult>& segmentation_results,
                    bool is_terminal);

  /// RecognitionResult dtor
  ~RecognitionResult() {}

  /// Returns a vector of unique string field names
  std::vector<std::string> GetStringFieldNames() const;
  /// Checks if there is a string field with given name
  bool HasStringField(const std::string& name) const;

  /**
   * @brief Gets string field by name
   * @param name - name of a string field
   *
   * @throws std::invalid_argument if there is no such field
   */
  const StringField& GetStringField(
      const std::string& name) const throw(std::exception);

  /**
   * @brief Getter for string fields map
   * @return constref for string fields map
   */
  const std::map<std::string, StringField>& GetStringFields() const;

  /**
   * @brief Getter for (mutable) string fields map
   * @return ref for string fields map
   */
  std::map<std::string, StringField>& GetStringFields();

  /**
   * @brief Setter for string fields map
   * @param string_fields - string fields map
   */
  void SetStringFields(const std::map<std::string, StringField>& string_fields);

  /// Returns a vector of unique image field names
  std::vector<std::string> GetImageFieldNames() const;
  /// Checks if there is a image field with given name
  bool HasImageField(const std::string& name) const;

  /**
   * @brief Gets image field by name
   * @param name - name of an image field
   *
   * @throws std::invalid_argument if there is no such field
   */
  const ImageField& GetImageField(
      const std::string& name) const throw(std::exception);

  /**
   * @brief Getter for image fields map
   * @return constref for image fields map
   */
  const std::map<std::string, ImageField>& GetImageFields() const;

  /**
   * @brief Getter for (mutable) image fields map
   * @return ref for image fields map
   */
  std::map<std::string, ImageField>& GetImageFields();

  /**
   * @brief Setter for image fields map
   * @param image_fields - image fields map
   */
  void SetImageFields(const std::map<std::string, ImageField>& image_fields);

  /// Getter for document type name. Empty string means empty result (no
  /// document match happened yet)
  const std::string& GetDocumentType() const;

  /// Setter for document type name
  void SetDocumentType(const std::string& doctype);

  /// Getter for match results - contains the most 'fresh' template quadrangles
  /// information available
  const std::vector<MatchResult>& GetMatchResults() const;
  /// Setter for match results
  void SetMatchResults(const std::vector<MatchResult>& match_results);

  /// Getter for segmentation results - contains the most 'fresh' zones
  /// and fields location information available
  const std::vector<SegmentationResult>& GetSegmentationResults() const;
  /// Setter for segmentation results
  void SetSegmentationResults(const std::vector<SegmentationResult>& segmentation_results);

  /**
   * @brief Whether the systems regards that result as 'final'.
   *        Could be (optionally) used to stop the recognition session.
   */
  bool IsTerminal() const;
  /// Setter for IsTerminal flag
  void SetIsTerminal(bool is_terminal);

private:
  std::map<std::string, StringField> string_fields_;
  std::map<std::string, ImageField> image_fields_;
  std::string document_type_;
  std::vector<MatchResult> match_results_;
  std::vector<SegmentationResult> segmentation_results_;
  bool is_terminal_;
};

/**
 * @brief Callback interface to obtain recognition results. Must be implemented
 *        to get the results as they appear during the stream processing
 */
class SMARTID_DLL_EXPORT ResultReporterInterface {
public:

  /**
   * @brief  Callback tells that last snapshot is not going to be
   *         processed/recognized. Optional
   */
  virtual void SnapshotRejected() {}

  /**
   * @brief  Callback tells that last snapshot has valid document and
             contains document match result. Optional
   * @param  match_result   Document match result - vector of found templates
   */
  virtual void DocumentMatched(const std::vector<MatchResult>& match_results) {}

  /**
   * @brief  Callback tells that last snapshot was segmented into fields and zones
   *         for each match result. Optional.
   * @param segmentation_results Segmentation results for each corresponding MatchResult
   */
  virtual void DocumentSegmented(const std::vector<SegmentationResult>& segmentation_results) {}

  /**
   * @brief  Callback tells that last snapshot was processed
   *         successfully and returns current result. Required
   * @param  recog_result       Current recognition result
   */
  virtual void SnapshotProcessed(const RecognitionResult& recog_result) = 0;

  /**
   * @brief Internal callback to stop the session (determined by internal timer)
   */
  virtual void SessionEnded() {}

  /**
   * @brief  Destructor
   */
  virtual ~ResultReporterInterface() {}
};

} } // namespace se::smartid

#if defined _MSC_VER
#pragma warning(pop)  
#endif

#endif // SMARTID_ENGINE_SMARTID_RESULT_H_INCLUDED
