import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Widget _buildTitleWithInputField(
  String language,
  bool showErrors,
  String title,
  String hintText,
  TextEditingController controller, {
  bool isText = false,
  bool isNumeric = false,
  bool isDate = false,
  bool isAlphanumeric = false,
  bool isGender = false,
  bool isPhone = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: language == 'ar'
          ? CrossAxisAlignment.end // Alignement à droite pour l'arabe
          : CrossAxisAlignment
              .start, // Alignement à gauche pour les autres langues
      children: [
        Text(
          title,
          textAlign: language == 'ar'
              ? TextAlign.right // Titre aligné à droite pour l'arabe
              : TextAlign.left, // Titre aligné à gauche pour les autres langues
          style: const TextStyle(
            fontSize: 16,
            color: Colors.green,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: isNumeric || isPhone
              ? TextInputType.number
              : isDate
                  ? TextInputType.datetime
                  : TextInputType.text,
          style:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          textAlign: language == 'ar'
              ? TextAlign.right
              : TextAlign.left, // Alignement du texte saisi
          textDirection: language == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr, // Direction du texte
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                const TextStyle(color: Color.fromARGB(255, 158, 158, 158)),
            hintTextDirection: language == 'ar'
                ? TextDirection.rtl // Hint aligné à droite pour l'arabe
                : TextDirection
                    .ltr, // Hint aligné à gauche pour les autres langues
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 7.0, horizontal: 5.0),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 112, 218, 115),
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 112, 218, 115),
                width: 3.5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (showErrors == false) return null;
            if (value == null || value.isEmpty) {
              return " ";
            }
            if (isText && !RegExp(r'^[A-Za-z\sء-ي]+$').hasMatch(value)) {
              return language == 'ar'
                  ? "يجب أن يحتوي على حروف فقط"
                  : "Only letters are allowed";
            }
            if (isNumeric && !RegExp(r'^[0-9\s]+$').hasMatch(value)) {
              return language == 'ar'
                  ? "يجب أن يحتوي على أرقام فقط"
                  : "Only numbers are allowed";
            }
            if (isDate && !RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
              return language == 'ar'
                  ? "يجب أن تكون التاريخ بتنسيق يوم/شهر/سنة"
                  : "Date must be in DD/MM/YYYY format";
            }
            if (isAlphanumeric &&
                !RegExp(r'^[A-Za-z0-9\sء-ي]+$').hasMatch(value)) {
              return language == 'ar'
                  ? "يجب أن يحتوي على أحرف وأرقام فقط"
                  : "Only letters and numbers are allowed";
            }
            if (isGender &&
                value.toLowerCase() != 'homme' &&
                value.toLowerCase() != 'femme' &&
                value.toLowerCase() != 'ذكر' &&
                value.toLowerCase() != 'أنثى') {
              return language == 'ar'
                  ? "أدخل 'ذكر' أو 'أنثى'"
                  : "Enter 'Male' or 'Female'";
            }
            if (isPhone &&
                !RegExp(r'^(05|06|07)\s?\d{2}\s?\d{2}\s?\d{2}\s?\d{2}$')
                    .hasMatch(value)) {
              return language == 'ar'
                  ? "يجب أن يحتوي الرقم على 10 أرقام ويبدأ بـ 05 أو 06 أو 07"
                  : "The number must contain 10 digits and start with 05, 06, or 07";
            }
            return null; // Le champ est valide
          },
        ),
      ],
    ),
  );
}

Widget _buildTitleWithDropdown(
  String language,
  bool showErrors,
  String title,
  String hintText,
  TextEditingController controller,
  List<String> options, {
  bool isRequired = false,
}) {
  String? selectedValue; // Gérer localement la valeur sélectionnée

  return StatefulBuilder(
    builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: language == 'ar'
              ? CrossAxisAlignment.end // Alignement à droite pour l'arabe
              : CrossAxisAlignment
                  .start, // Alignement à gauche pour les autres langues
          children: [
            Text(
              title,
              textAlign: language == 'ar' ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: selectedValue,
              onChanged: (newValue) {
                setState(() {
                  selectedValue = newValue;
                });
              },
              isExpanded: true,
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    textAlign:
                        language == 'ar' ? TextAlign.right : TextAlign.left,
                    textDirection: language == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 158, 158, 158)),
                hintTextDirection:
                    language == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 7.0, horizontal: 5.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 112, 218, 115), width: 2.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 112, 218, 115), width: 3.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              /*validator: (value) {
                if (isRequired && (value == null || value.isEmpty)) {
                  return " ";
                }
                return null;
              },*/
            ),
          ],
        ),
      );
    },
  );
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool isPage1Valid = false;
  bool isPage2Valid = false;
  bool isPage3Valid = false;
  bool isPage4Valid = false;
  bool isPage5Valid = false;
  bool isPage6Valid = false;
  Future<void> _selectImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path); // Stocker l'image sélectionnée
      });
    }
  }

  void updatePageStatus(int pageIndex, bool isValid) {
    setState(() {
      _showErrors = true;
      if (pageIndex == 0) {
        isPage1Valid = isValid;
      } else if (pageIndex == 1) {
        isPage2Valid = isValid;
      } else if (pageIndex == 2) {
        isPage3Valid = isValid;
      } else if (pageIndex == 3) {
        isPage4Valid = isValid;
      } else if (pageIndex == 4) {
        isPage5Valid = isValid;
      } else if (pageIndex == 5) {
        isPage6Valid = isValid;
      }
    });
  }

  bool _showErrors = false;

  // Fonction pour naviguer vers la page suivante
  void goToNextPage() {
    setState(() {
      _showErrors = true;
    });
    if (_currentPage == 0 && isPage1Valid ||
        _currentPage == 1 && isPage2Valid ||
        _currentPage == 2 && isPage3Valid ||
        _currentPage == 3 && isPage4Valid ||
        _currentPage == 4 && isPage5Valid ||
        _currentPage == 5 && isPage6Valid) {
      setState(() {
        if (_currentPage < 5) {
          _currentPage++;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _language == 'ar'
                ? "يرجى ملء جميع الحقول بشكل صحيح قبل المتابعة."
                : "Please fill in all fields correctly before continuing.",
            textAlign: _language == 'ar' ? TextAlign.right : TextAlign.left,
            textDirection:
                _language == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          ),
        ),
      );
    }
  }

  // Méthode pour revenir à la page précédente
  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String _language = 'ar'; // Par défaut, la langue est arabe

  void _changeLanguage(String? language) {
    setState(() {
      _language = language!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 112, 218, 115), // Couleur verte
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Bouton de traduction
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: DropdownButton<String>(
                    value: _language,
                    items: const [
                      DropdownMenuItem(
                        value: 'ar',
                        child: Text('العربية',
                            style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('English',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                    onChanged: _changeLanguage,
                    dropdownColor:
                        Colors.green, // Pour une meilleure visibilité
                    icon: const Icon(Icons.language, color: Colors.white),
                  ),
                ),
              ),
              // Section icône et titre
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/saudi.png",
                    width: screenWidth * 0.2,
                    height: screenHeight * 0.2,
                  ),
                  SizedBox(width: screenWidth * 0.002), // Espacement adaptatif
                  Column(
                    children: [
                      Text(
                        '-سفارة المملكة العربية السعودية -القسم القنصلي ',
                        style: TextStyle(
                          fontSize:
                              screenWidth * 0.02, // Taille du texte adaptative
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'EMBASSY OF SAUDI ARABIA - CONSULAR SECTION -',
                        style: TextStyle(
                          fontSize:
                              screenWidth * 0.02, // Taille du texte adaptative
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.0), // Espacement adaptatif
              // Grand espace blanc avec PageView et boutons
              Container(
                width: screenWidth * 0.9, // Largeur adaptative
                height: screenHeight * 0.7, // Hauteur adaptative
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0,
                            right: 20.0), // Positionner en haut à droite
                        child: Row(
                          mainAxisSize: MainAxisSize
                              .min, // Garde la taille minimale pour la rangée
                          children: List.generate(6, (index) {
                            return Container(
                              width: 12.0, // Taille du cercle
                              height: 12.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal:
                                      5.0), // Espacement entre les cercles
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index <= _currentPage
                                    ? Colors.green
                                    : Colors.grey[300],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),

                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        children: [
                          Page1(
                            showErrors: _showErrors,
                            selectedImage: _selectedImage,
                            onImagePick: _selectImageFromGallery,
                            updatePageStatus: updatePageStatus,
                            language: _language, // Passer la fonction
                          ),
                          Page2(
                            showErrors: _showErrors,
                            updatePageStatus: updatePageStatus,
                            language: _language,
                          ),
                          Page3(
                              showErrors: _showErrors,
                              updatePageStatus: updatePageStatus,
                              language: _language),
                          Page4(
                              showErrors: _showErrors,
                              updatePageStatus: updatePageStatus,
                              language: _language),
                          Page5(
                              showErrors: _showErrors,
                              updatePageStatus: updatePageStatus,
                              language: _language),
                          Page6(
                              showErrors: _showErrors,
                              updatePageStatus: updatePageStatus,
                              language: _language),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: screenHeight * 0.02), // Espacement adaptatif
                    // Boutons Suivant et Précédent
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed:
                              _currentPage == 0 ? null : _goToPreviousPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _currentPage == 0
                                ? Colors.grey
                                : const Color.fromARGB(255, 112, 218, 115),
                          ),
                          child: Text(
                            _language == 'ar'
                                ? 'السابق'
                                : 'Previous', // Texte du bouton basé sur la langue
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),

                        SizedBox(
                            width: screenWidth *
                                0.05), // Espacement entre les boutons

                        ElevatedButton(
                          onPressed: () {
                            // Vérification si on est à la dernière page
                            if (_currentPage == 5) {
                              // Vérifier si tous les champs de la page actuelle sont valides
                              if (isPage6Valid) {
                                // Afficher le message de succès dans un dialog personnalisé
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Colors.green[
                                        50], // Couleur de fond verte claire
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons
                                              .check_circle, // Icône de check verte
                                          color: Colors.green,
                                          size: 30,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          _language == 'ar'
                                              ? 'تم إرسال النموذج بنجاح'
                                              : 'Form submitted successfully',
                                          style: TextStyle(
                                            color: Colors
                                                .green[800], // Couleur du texte
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                // Afficher un message d'erreur si les champs ne sont pas valides
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      _language == 'ar'
                                          ? "يرجى ملء جميع الحقول بشكل صحيح قبل المتابعة."
                                          : "Please fill in all fields correctly before continuing.",
                                      textAlign: _language == 'ar'
                                          ? TextAlign.right
                                          : TextAlign.left,
                                      textDirection: _language == 'ar'
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              // Si on n'est pas à la dernière page, continuer normalement
                              goToNextPage();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _currentPage == 5
                                ? Colors.green
                                : const Color.fromARGB(255, 112, 218, 115),
                          ),
                          child: Text(
                            _currentPage == 5
                                ? (_language == 'ar' ? 'إرسال' : 'Submit')
                                : (_language == 'ar' ? 'التالي' : 'Next'),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: screenHeight * 0.02), // Espacement adaptatif
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Page1 extends StatefulWidget {
  final bool showErrors;
  final File? selectedImage;
  final Function() onImagePick;
  final Function(int, bool) updatePageStatus;
  final String _language; // Add language parameter

  const Page1(
      {super.key,
      required this.showErrors,
      required this.selectedImage,
      required this.onImagePick,
      required this.updatePageStatus,
      required String language})
      : _language = language;

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nameMereController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedOption = 'no option';

  late String nameCompletValid;

  @override
  void initState() {
    super.initState();

    // Adding listeners for each field

    nameController.addListener(_checkFieldsFilled);
    nameMereController.addListener(_checkFieldsFilled);
    statusController.addListener(_checkFieldsFilled);
    genreController.addListener(_checkFieldsFilled);
    adresseController.addListener(_checkFieldsFilled);
    numeroController.addListener(_checkFieldsFilled);
  }

  void _checkFieldsFilled() {
    setState(() {
      final isImageSelected = widget.selectedImage != null;

      if (_formKey.currentState!.validate() && isImageSelected) {
        widget.updatePageStatus(0, true);
      } else {
        widget.updatePageStatus(0, false);
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    nameMereController.dispose();
    adresseController.dispose();
    numeroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Space between the form and buttons
            children: [
              // Form section
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget._language == 'ar'
                                  ? 'اضغط لاختيار صورة الهوية الخاصة بك:'
                                  : 'Press to select your ID photo:',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 112, 218, 115),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            GestureDetector(
                              onTap: widget.onImagePick,
                              child: widget.selectedImage != null
                                  ? Image.file(
                                      widget.selectedImage!,
                                      width: screenWidth * 0.25,
                                      height: screenHeight * 0.25,
                                    )
                                  : Image.asset(
                                      'assets/images/image.png',
                                      width: screenWidth * 0.25,
                                      height: screenHeight * 0.25,
                                    ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTitleWithInputField(
                                widget._language,
                                widget.showErrors,
                                widget._language == 'ar'
                                    ? 'الاسم الكامل'
                                    : 'Full Name',
                                widget._language == 'ar'
                                    ? 'أدخل الاسم الكامل'
                                    : 'Enter full name',
                                nameController,
                                isText: true),
                            _buildTitleWithInputField(
                                widget._language,
                                widget.showErrors,
                                widget._language == 'ar'
                                    ? 'اسم الأم'
                                    : 'Mother\'s Name',
                                widget._language == 'ar'
                                    ? 'أدخل اسم الأم'
                                    : 'Enter mother\'s name',
                                nameMereController,
                                isText: true),
                            _buildTitleWithDropdown(
                              widget._language, // Langue
                              widget.showErrors, // Gestion des erreurs
                              widget._language == 'ar'
                                  ? 'الحالة'
                                  : 'Status', // Titre
                              widget._language == 'ar'
                                  ? 'أدخل الحالة'
                                  : 'Enter status', // Texte indicatif (hintText)
                              statusController, // Controller
                              widget._language == 'ar'
                                  ? ['عازب', 'متزوج', 'مطلق', 'أرمل']
                                  : [
                                      'Single',
                                      'Married',
                                      'Divorced',
                                      'Widowed'
                                    ], // Liste des options (à personnaliser selon votre contexte)
                              isRequired: true, // Exemple d'option booléenne
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTitleWithDropdown(
                              widget._language,
                              widget.showErrors,
                              widget._language == 'ar' ? 'الجنس' : 'Gender',
                              widget._language == 'ar'
                                  ? 'أدخل الجنس'
                                  : 'Enter gender',
                              genreController,
                              widget._language == 'ar'
                                  ? ['ذكر', 'أنثى'] // Options en arabe
                                  : ['Male', 'Female'], // Options en anglais
                              isRequired: true,
                            ),
                            _buildTitleWithInputField(
                                widget._language,
                                widget.showErrors,
                                widget._language == 'ar'
                                    ? 'العنوان'
                                    : 'Address',
                                widget._language == 'ar'
                                    ? 'أدخل العنوان'
                                    : 'Enter address',
                                adresseController,
                                isAlphanumeric: true),
                            _buildTitleWithInputField(
                                widget._language,
                                widget.showErrors,
                                widget._language == 'ar'
                                    ? 'رقم الهاتف'
                                    : 'Phone Number',
                                widget._language == 'ar'
                                    ? 'أدخل رقم الهاتف'
                                    : 'Enter phone number',
                                numeroController,
                                isPhone: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Page2 extends StatefulWidget {
  final bool showErrors;

  final String _language; // Add language parameter
  const Page2(
      {super.key,
      required this.showErrors,
      required this.updatePageStatus,
      required String language})
      : _language = language;

  final Function(int, bool) updatePageStatus;

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final TextEditingController placeBirthController = TextEditingController();
  final TextEditingController dateBirthController = TextEditingController();
  final TextEditingController presentNationController = TextEditingController();
  final TextEditingController previousNationController =
      TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController seetController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Add listeners for field validation
    placeBirthController.addListener(_checkFieldsFilled);
    dateBirthController.addListener(_checkFieldsFilled);
    presentNationController.addListener(_checkFieldsFilled);
    previousNationController.addListener(_checkFieldsFilled);
    religionController.addListener(_checkFieldsFilled);
    seetController.addListener(_checkFieldsFilled);
  }

  // Function to check if all fields are filled
  void _checkFieldsFilled() {
    setState(() {
      if (_formKey.currentState!.validate()) {
        widget.updatePageStatus(1, true);
      } else {
        widget.updatePageStatus(1, false);
      }
    });
  }

  @override
  void dispose() {
    // Release resources for controllers
    placeBirthController.dispose();
    dateBirthController.dispose();
    presentNationController.dispose();
    previousNationController.dispose();
    religionController.dispose();
    seetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTitleWithInputField(
                          widget._language,
                          widget.showErrors,
                          widget._language == 'ar'
                              ? 'مكان الولادة'
                              : 'PLACE OF BIRTH',
                          widget._language == 'ar'
                              ? 'أدخل مكان الولادة'
                              : 'Enter place of birth',
                          placeBirthController,
                          isText: true),
                      _buildTitleWithInputField(
                          widget._language,
                          widget.showErrors,
                          widget._language == 'ar'
                              ? 'تاريخ الولادة'
                              : 'DATE OF BIRTH',
                          widget._language == 'ar'
                              ? 'اليوم/الشهر/السنة'
                              : 'jj/mm/aaaa',
                          dateBirthController,
                          isDate: true),
                      _buildTitleWithInputField(
                          widget._language,
                          widget.showErrors,
                          widget._language == 'ar'
                              ? 'الدولة الحالية'
                              : 'PRESENT NATION',
                          widget._language == 'ar'
                              ? 'أدخل الدولة الحالية'
                              : 'Enter present nation',
                          presentNationController,
                          isText: true),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTitleWithInputField(
                          widget._language,
                          widget.showErrors,
                          widget._language == 'ar'
                              ? 'الدولة السابقة'
                              : 'PREVIOUS NATION',
                          widget._language == 'ar'
                              ? 'أدخل الدولة السابقة'
                              : 'Enter previous nation',
                          previousNationController,
                          isText: true),
                      _buildTitleWithDropdown(
                        widget._language,
                        widget.showErrors,
                        widget._language == 'ar' ? 'الدين' : 'Religion',
                        widget._language == 'ar'
                            ? 'أدخل الدين'
                            : 'Enter religion',
                        religionController,
                        widget._language == 'ar'
                            ? [
                                'الإسلام',
                                'المسيحية',
                                'اليهودية',
                                'الهندوسية',
                                'البوذية',
                                'أخرى'
                              ]
                            : [
                                'Islam',
                                'Christianity',
                                'Judaism',
                                'Hinduism',
                                'Buddhism',
                                'Other'
                              ],
                        isRequired: true,
                      ),
                      _buildTitleWithDropdown(
                        widget._language,
                        widget.showErrors,
                        widget._language == 'ar' ? 'الطائفة' : 'Sect',
                        widget._language == 'ar'
                            ? 'أدخل الطائفة'
                            : 'Enter your sect',
                        seetController,
                        widget._language == 'ar'
                            ? [
                                'جميع الطوائف',
                                'سني',
                                'شيعي',
                                'درزي',
                                'علوي',
                                'كاثوليكي',
                                'بروتستانتي',
                                'أرثوذكسي',
                                'إنجيلي',
                                'أرثوذكسي يهودي',
                                'تقليدي',
                                'إصلاح',
                                'إعادة بناء',
                                'فايشنافية',
                                'شيفية',
                                'شاكتي',
                                'سمارتي',
                                'تيرافادا',
                                'ماهايانا',
                                'فاجرايانا',
                                'أخرى'
                              ]
                            : [
                                'All Sects',
                                'Sunni',
                                'Shia',
                                'Druze',
                                'Alawite',
                                'Catholic',
                                'Protestant',
                                'Orthodox',
                                'Evangelical',
                                'Orthodox Jewish',
                                'Conservative',
                                'Reform',
                                'Reconstructionist',
                                'Vaishnavism',
                                'Shaivism',
                                'Shaktism',
                                'Smartism',
                                'Theravada',
                                'Mahayana',
                                'Vajrayana',
                                'Other'
                              ],
                        isRequired: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Page3 extends StatefulWidget {
  final bool showErrors;

  final String _language; // Add language parameter
  const Page3(
      {super.key,
      required this.showErrors,
      required this.updatePageStatus,
      required String language})
      : _language = language;

  final Function(int, bool) updatePageStatus;

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  final TextEditingController professionController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController adressCompanyController = TextEditingController();
  final TextEditingController numCompanyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Add listeners for field validation
    professionController.addListener(_checkFieldsFilled);
    qualificationController.addListener(_checkFieldsFilled);
    sourceController.addListener(_checkFieldsFilled);
    adressCompanyController.addListener(_checkFieldsFilled);
    numCompanyController.addListener(_checkFieldsFilled);
  }

  @override
  void dispose() {
    // Release resources for controllers
    professionController.dispose();
    qualificationController.dispose();
    sourceController.dispose();
    adressCompanyController.dispose();
    numCompanyController.dispose();
    super.dispose();
  }

  // Function to check if all fields are filled
  void _checkFieldsFilled() {
    setState(() {
      if (_formKey.currentState!.validate()) {
        widget.updatePageStatus(2, true);
      } else {
        widget.updatePageStatus(2, false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTitleWithInputField(
                          widget._language,
                          widget.showErrors,
                          widget._language == 'ar' ? 'المهنة' : 'PROFESSION',
                          widget._language == 'ar'
                              ? 'أدخل المهنة'
                              : 'Enter profession',
                          professionController,
                          isText: true),
                      _buildTitleWithInputField(
                          widget._language,
                          widget.showErrors,
                          widget._language == 'ar' ? 'المؤهل' : 'QUALIFICATION',
                          widget._language == 'ar'
                              ? 'أدخل مؤهلاتك'
                              : 'Enter your qualification',
                          qualificationController,
                          isText: true),
                      _buildTitleWithInputField(
                          widget._language,
                          widget.showErrors,
                          widget._language == 'ar' ? 'المصدر' : 'SOURCE',
                          widget._language == 'ar'
                              ? 'أدخل المصدر'
                              : 'Enter the source',
                          sourceController,
                          isText: true),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTitleWithInputField(
                          widget._language,
                          widget.showErrors,
                          widget._language == 'ar'
                              ? 'عنوان الشركة'
                              : "COMPANY'S ADDRESS",
                          widget._language == 'ar'
                              ? 'أدخل عنوان الشركة'
                              : 'Enter company address',
                          adressCompanyController,
                          isAlphanumeric: true),
                      _buildTitleWithInputField(
                          widget._language,
                          widget.showErrors,
                          widget._language == 'ar'
                              ? 'رقم الشركة'
                              : "COMPANY'S NUMBER",
                          widget._language == 'ar'
                              ? 'أدخل رقم الشركة'
                              : 'Enter company number',
                          numCompanyController,
                          isNumeric: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Page4 extends StatefulWidget {
  final bool showErrors;

  final String _language; // Add language parameter
  const Page4(
      {super.key,
      required this.showErrors,
      required this.updatePageStatus,
      required String language})
      : _language = language;

  final Function updatePageStatus;

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  // Declare all the necessary controllers
  final TextEditingController reasonTravelController = TextEditingController();
  final TextEditingController numPassController = TextEditingController();
  final TextEditingController dateEditController = TextEditingController();
  final TextEditingController placeIssueController = TextEditingController();
  final TextEditingController passExpiController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Add listeners for each field
    reasonTravelController.addListener(_checkFieldsFilled);
    numPassController.addListener(_checkFieldsFilled);
    dateEditController.addListener(_checkFieldsFilled);
    placeIssueController.addListener(_checkFieldsFilled);
    passExpiController.addListener(_checkFieldsFilled);
  }

  @override
  void dispose() {
    // Release controllers when the page is disposed
    reasonTravelController.dispose();
    numPassController.dispose();
    dateEditController.dispose();
    placeIssueController.dispose();
    passExpiController.dispose();
    super.dispose();
  }

  // Check if all fields are filled
  void _checkFieldsFilled() {
    setState(() {
      if (_formKey.currentState!.validate()) {
        widget.updatePageStatus(3, true); // Page 4 is filled
      } else {
        widget.updatePageStatus(3, false); // Page 4 is not filled
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTitleWithInputField(
                        widget._language,
                        widget.showErrors,
                        widget._language == 'ar'
                            ? 'غرض السفر'
                            : 'PURPOSE OF TRAVEL :',
                        widget._language == 'ar'
                            ? 'أدخل غرض السفر'
                            : 'Enter purpose of travel',
                        reasonTravelController,
                        isText: true,
                      ),
                      _buildTitleWithInputField(
                        widget._language,
                        widget.showErrors,
                        widget._language == 'ar'
                            ? 'رقم الجواز'
                            : 'PASSPORT NO :',
                        widget._language == 'ar'
                            ? 'أدخل رقم الجواز'
                            : 'Enter passport number',
                        numPassController,
                        isNumeric: true,
                      ),
                      _buildTitleWithInputField(
                        widget._language,
                        widget.showErrors,
                        widget._language == 'ar'
                            ? 'تاريخ إصدار الجواز'
                            : 'DATE PASSPORT ISSUED',
                        widget._language == 'ar'
                            ? 'أدخل تاريخ إصدار الجواز'
                            : 'Enter passport issue date',
                        dateEditController,
                        isDate: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTitleWithInputField(
                        widget._language,
                        widget.showErrors,
                        widget._language == 'ar'
                            ? 'مكان الإصدار'
                            : 'PLACE OF ISSUE',
                        widget._language == 'ar'
                            ? 'أدخل مكان إصدار الجواز'
                            : 'Enter place of issue',
                        placeIssueController,
                        isAlphanumeric: true,
                      ),
                      _buildTitleWithInputField(
                        widget._language,
                        widget.showErrors,
                        widget._language == 'ar'
                            ? 'تاريخ انتهاء الجواز'
                            : 'PASSPORT\'S EXPIRY',
                        widget._language == 'ar'
                            ? 'أدخل تاريخ انتهاء الجواز'
                            : 'Enter passport expiry date',
                        passExpiController,
                        isDate: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Page5 extends StatefulWidget {
  final bool showErrors;

  final String _language; // Add language parameter
  const Page5(
      {super.key,
      required this.showErrors,
      required this.updatePageStatus,
      required String language})
      : _language = language;

  final Function updatePageStatus;

  @override
  State<Page5> createState() => _Page5State();
}

class _Page5State extends State<Page5> {
  // Declare all the necessary controllers
  final TextEditingController modePayController = TextEditingController();
  final TextEditingController numPayController = TextEditingController();
  final TextEditingController datePayController = TextEditingController();
  final TextEditingController noController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Add listeners for each field if necessary for validation
    modePayController.addListener(_checkFieldsFilled);
    numPayController.addListener(_checkFieldsFilled);
    datePayController.addListener(_checkFieldsFilled);
    noController.addListener(_checkFieldsFilled);
    dateController.addListener(_checkFieldsFilled);
  }

  @override
  void dispose() {
    // Release the controllers when the widget is disposed
    modePayController.dispose();
    numPayController.dispose();
    datePayController.dispose();
    noController.dispose();
    dateController.dispose();
    super.dispose();
  }

  // Check if all fields are filled or not to change the page status
  void _checkFieldsFilled() {
    setState(() {
      if (_formKey.currentState!.validate()) {
        widget.updatePageStatus(4, true);
      } else {
        widget.updatePageStatus(4, false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTitleWithInputField(
                        widget._language,
                        widget.showErrors,
                        widget._language == 'ar'
                            ? 'طريقة الدفع'
                            : 'MODE OF PAYEMENT :',
                        widget._language == 'ar'
                            ? 'أدخل طريقة الدفع'
                            : 'Enter payment mode',
                        modePayController,
                        isText: true,
                      ),
                      _buildTitleWithInputField(
                        widget._language,
                        widget.showErrors,
                        widget._language == 'ar' ? 'رقم الدفع' : 'PAYMENT NO :',
                        widget._language == 'ar'
                            ? 'أدخل رقم الدفع'
                            : 'Enter payment number',
                        numPayController,
                        isNumeric: true,
                      ),
                      _buildTitleWithInputField(
                        widget._language,
                        widget.showErrors,
                        widget._language == 'ar'
                            ? 'تاريخ الدفع'
                            : 'PAYMENT DATE :',
                        widget._language == 'ar'
                            ? 'أدخل تاريخ الدفع'
                            : 'Enter the payment date',
                        datePayController,
                        isDate: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTitleWithInputField(
                        widget._language,
                        widget.showErrors,
                        widget._language == 'ar' ? 'رقم ...' : 'NO OF ... :',
                        widget._language == 'ar'
                            ? 'أدخل الرقم'
                            : 'Enter the number',
                        noController,
                        isNumeric: true,
                      ),
                      _buildTitleWithInputField(
                        widget._language,
                        widget.showErrors,
                        widget._language == 'ar'
                            ? 'تاريخ ....'
                            : 'DATE OF ....... :',
                        widget._language == 'ar'
                            ? 'أدخل التاريخ'
                            : 'Enter the date',
                        dateController,
                        isDate: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Page6 extends StatefulWidget {
  final bool showErrors;

  final String _language; // Add language parameter
  const Page6(
      {super.key,
      required this.showErrors,
      required this.updatePageStatus,
      required String language})
      : _language = language;

  final Function updatePageStatus;

  @override
  State<Page6> createState() => _Page6State();
}

class _Page6State extends State<Page6> {
  final TextEditingController dateLeaveController = TextEditingController();
  final TextEditingController dateArriveController = TextEditingController();
  final TextEditingController dureeController = TextEditingController();
  final TextEditingController nameMahramController = TextEditingController();
  final TextEditingController relationController = TextEditingController();
  final TextEditingController nameCompanyController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Add listeners for each field
    dateLeaveController.addListener(_checkFieldsFilled);
    dateArriveController.addListener(_checkFieldsFilled);
    dureeController.addListener(_checkFieldsFilled);
    nameMahramController.addListener(_checkFieldsFilled);
    relationController.addListener(_checkFieldsFilled);
    nameCompanyController.addListener(_checkFieldsFilled);
    destinationController.addListener(_checkFieldsFilled);
  }

  @override
  void dispose() {
    // Release controllers when the widget is disposed
    dateLeaveController.dispose();
    dateArriveController.dispose();
    dureeController.dispose();
    nameMahramController.dispose();
    relationController.dispose();
    nameCompanyController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  // Check if all fields are filled and update the page status
  void _checkFieldsFilled() {
    setState(() {
      if (_formKey.currentState!.validate()) {
        widget.updatePageStatus(5, true);
      } else {
        widget.updatePageStatus(5, false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          // Ajout de SingleChildScrollView pour éviter l'overflow
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTitleWithInputField(
                          widget._language,
                          widget.showErrors,
                          widget._language == 'ar'
                              ? 'تاريخ المغادرة'
                              : 'DATE OF DEPARTURE',
                          widget._language == 'ar'
                              ? 'ادخل تاريخ المغادرة'
                              : 'jj/mm/aaaa',
                          dateLeaveController,
                          isDate: true,
                        ),
                        _buildTitleWithInputField(
                          widget._language,
                          widget.showErrors,
                          widget._language == 'ar'
                              ? 'تاريخ الوصول'
                              : 'DATE OF ARRIVAL',
                          widget._language == 'ar'
                              ? 'ادخل تاريخ الوصول'
                              : 'jj/mm/aaaa',
                          dateArriveController,
                          isDate: true,
                        ),
                        _buildTitleWithInputField(
                          widget._language,
                          widget.showErrors,
                          widget._language == 'ar'
                              ? 'مدة الإقامة'
                              : 'DURATION OF STAY',
                          widget._language == 'ar'
                              ? 'المدة بالأيام'
                              : 'Duration in days',
                          dureeController,
                          isNumeric: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTitleWithInputField(
                          widget._language,
                          widget.showErrors,
                          widget._language == 'ar'
                              ? 'اسم المحرم'
                              : 'NAME OF MAHRAM',
                          widget._language == 'ar'
                              ? 'ادخل اسم المحرم'
                              : 'Enter name of Mahram',
                          nameMahramController,
                          isText: true,
                        ),
                        _buildTitleWithInputField(
                          widget._language,
                          widget.showErrors,
                          widget._language == 'ar' ? 'العلاقة' : 'RELATIONSHIP',
                          widget._language == 'ar'
                              ? 'ادخل العلاقة مع المحرم'
                              : 'Enter relationship to Mahram',
                          relationController,
                          isText: true,
                        ),
                        _buildTitleWithInputField(
                          widget._language,
                          widget.showErrors,
                          widget._language == 'ar'
                              ? 'اسم الناقل'
                              : 'CARRIER NAME',
                          widget._language == 'ar'
                              ? 'ادخل اسم الناقل'
                              : 'Enter name of carrier',
                          nameCompanyController,
                          isText: true,
                        ),
                        _buildTitleWithInputField(
                          widget._language,
                          widget.showErrors,
                          widget._language == 'ar' ? 'الوجهة' : 'DESTINATION',
                          widget._language == 'ar'
                              ? 'ادخل الوجهة'
                              : 'Enter travel destination',
                          destinationController,
                          isText: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
