import 'package:babi_industries/controllers/auth_controller.dart';
import 'package:babi_industries/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;
  String? _selectedRole;

  final List<Map<String, dynamic>> _roles = [
    {
      'id': 'supply_chain_manager',
      'title': 'Supply Chain Manager',
      'description': 'Manage suppliers, analytics, and operations',
      'icon': Icons.analytics,
      'color': Colors.blue,
      'permissions': ['Dashboard', 'Suppliers', 'Orders', 'Analytics']
    },
    {
      'id': 'senior_buyer',
      'title': 'Senior Buyer',
      'description': 'Create orders and manage supplier relationships',
      'icon': Icons.shopping_cart,
      'color': Colors.green,
      'permissions': ['Orders', 'Suppliers', 'Purchasing']
    },
    {
      'id': 'warehouse_manager',
      'title': 'Warehouse Manager',
      'description': 'Inventory control and warehouse operations',
      'icon': Icons.warehouse,
      'color': Colors.orange,
      'permissions': ['Inventory', 'Receiving', 'Shipping', 'Mobile App']
    },
    {
      'id': 'logistics_coordinator',
      'title': 'Logistics Coordinator',
      'description': 'Track shipments and coordinate deliveries',
      'icon': Icons.local_shipping,
      'color': Colors.purple,
      'permissions': ['Tracking', 'Shipping', 'Customer Communication']
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _employeeIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF3B82F6),
              Color(0xFF60A5FA),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _buildBackgroundPattern(),
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 16 : 20,
                    vertical: 16,
                  ),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: isSmallScreen ? screenWidth * 0.95 : 450,
                              ),
                              child: _buildRegisterCard(isSmallScreen),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterCard(bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 32),
          _buildHeader(isSmallScreen),
          const SizedBox(height: 8),
          Text(
            'Join Your Supply Chain Team',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          _buildRegisterForm(isSmallScreen),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    return Column(
      children: [
        Container(
          width: isSmallScreen ? 80 : 90,
          height: isSmallScreen ? 80 : 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: isSmallScreen ? 60 : 70,
                height: isSmallScreen ? 60 : 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              Container(
                width: isSmallScreen ? 40 : 45,
                height: isSmallScreen ? 40 : 45,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1E40AF),
                ),
                child: Icon(
                  Icons.business_center,
                  color: Colors.white,
                  size: isSmallScreen ? 22 : 25,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Babi Industries',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E40AF),
            letterSpacing: 1.0,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Supply Chain Management Platform',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegisterForm(bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 28),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputLabel('Full Name'),
            const SizedBox(height: 8),
            _buildNameField(isSmallScreen),
            const SizedBox(height: 16),
            _buildInputLabel('Email Address'),
            const SizedBox(height: 8),
            _buildEmailField(isSmallScreen),
            const SizedBox(height: 16),
            _buildInputLabel('Phone Number'),
            const SizedBox(height: 8),
            _buildPhoneField(isSmallScreen),
            const SizedBox(height: 16),
            _buildInputLabel('Employee ID (Optional)'),
            const SizedBox(height: 8),
            _buildEmployeeIdField(isSmallScreen),
            const SizedBox(height: 20),
            _buildRoleSelectionResponsive(isSmallScreen),
            const SizedBox(height: 20),
            _buildInputLabel('Password'),
            const SizedBox(height: 8),
            _buildPasswordField(isSmallScreen),
            const SizedBox(height: 16),
            _buildInputLabel('Confirm Password'),
            const SizedBox(height: 8),
            _buildConfirmPasswordField(isSmallScreen),
            const SizedBox(height: 20),
            _buildTermsCheckbox(),
            const SizedBox(height: 28),
            _buildRegisterButton(),
            const SizedBox(height: 20),
            _buildLoginLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeIdField(bool isSmallScreen) {
    return TextFormField(
      controller: _employeeIdController,
      decoration: _inputDecoration('Enter Employee ID'),
    );
  }

  Widget _buildRoleSelectionResponsive(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.work_outline, color: Colors.blue[700], size: 20),
            const SizedBox(width: 8),
            Text(
              'Select Your Role',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: isSmallScreen ? 180 : null,
          child: isSmallScreen
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _roles.length,
                  itemBuilder: (context, index) {
                    final role = _roles[index];
                    return Container(
                      width: 250,
                      margin: const EdgeInsets.only(right: 12),
                      child: _buildRoleCard(role),
                    );
                  },
                )
              : Column(
                  children: _roles.map((role) => _buildRoleCard(role)).toList(),
                ),
        ),
        if (_selectedRole == null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Please select a role to continue',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
      ],
    );
  }

  Widget _buildRoleCard(Map<String, dynamic> role) {
    final isSelected = _selectedRole == role['id'];
    final color = role['color'] as Color;

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? color : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedRole = role['id'];
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(role['icon'], color: color, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      role['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                role['description'],
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: (role['permissions'] as List<String>)
                      .map(
                        (perm) => Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            perm,
                            style: TextStyle(
                                color: color,
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget _buildNameField(bool isSmallScreen) {
    return TextFormField(
      controller: _nameController,
      decoration: _inputDecoration('Enter full name'),
      validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
    );
  }

  Widget _buildEmailField(bool isSmallScreen) {
    return TextFormField(
      controller: _emailController,
      decoration: _inputDecoration('Enter email address'),
      keyboardType: TextInputType.emailAddress,
      validator: (value) => value!.isEmpty ? 'Email cannot be empty' : null,
    );
  }

  Widget _buildPhoneField(bool isSmallScreen) {
    return TextFormField(
      controller: _phoneController,
      decoration: _inputDecoration('Enter phone number'),
      keyboardType: TextInputType.phone,
      validator: (value) =>
          value!.isEmpty ? 'Phone number cannot be empty' : null,
    );
  }

  Widget _buildPasswordField(bool isSmallScreen) {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: _inputDecoration('Enter password').copyWith(
        suffixIcon: IconButton(
          icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) =>
          value!.isEmpty ? 'Password cannot be empty' : null,
    );
  }

  Widget _buildConfirmPasswordField(bool isSmallScreen) {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isConfirmPasswordVisible,
      decoration: _inputDecoration('Confirm password').copyWith(
        suffixIcon: IconButton(
          icon: Icon(_isConfirmPasswordVisible
              ? Icons.visibility
              : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Please confirm your password';
        if (value != _passwordController.text) return 'Passwords do not match';
        return null;
      },
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value!;
            });
          },
        ),
        Flexible(
          child: Text(
            'I accept the terms and conditions',
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () {
                if (_formKey.currentState!.validate() &&
                    _selectedRole != null &&
                    _acceptTerms) {
                  _registerUser();
                } else {
                  Get.snackbar(
                    'Error',
                    'Please fill all fields, select a role, and accept terms',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Register',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account? '),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.LOGIN),
          child: const Text(
            'Login',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }
void _registerUser() async {
  if (_formKey.currentState!.validate() && _selectedRole != null && _acceptTerms) {
    setState(() {
      _isLoading = true;
    });

    try {
      // Map the role ID to the proper role name
      String roleName = '';
      switch (_selectedRole) {
        case 'supply_chain_manager':
          roleName = 'Supply Chain Manager';
          break;
        case 'senior_buyer':
          roleName = 'Buyer';
          break;
        case 'warehouse_manager':
          roleName = 'Warehouse Manager';
          break;
        case 'logistics_coordinator':
          roleName = 'Logistics Coordinator';
          break;
      }

      final success = await AuthController.instance.registerUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        employeeId: _employeeIdController.text.trim().isEmpty 
            ? 'EMP${DateTime.now().millisecondsSinceEpoch}'
            : _employeeIdController.text.trim(),
        password: _passwordController.text.trim(),
        role: roleName,
        company: 'Babi Industries',
      );

      if (success) {
        Get.snackbar(
          'Success', 
          'Registration successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Navigate to role-based dashboard
        final route = AuthController.instance.getDashboardRouteForRole(roleName);
        Get.offAllNamed(route);
      }
    } catch (e) {
      Get.snackbar(
        'Error', 
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  } else {
    Get.snackbar(
      'Error',
      'Please fill all fields, select a role, and accept terms',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.05,
        child: Image.asset(
          'assets/images/pattern.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
