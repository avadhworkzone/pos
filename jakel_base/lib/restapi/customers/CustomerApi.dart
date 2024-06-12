import 'package:jakel_base/restapi/customers/model/CreateCustomerRequest.dart';
import 'package:jakel_base/restapi/customers/model/CustomerRaceResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomerResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomerTitlesResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomerTypesResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/customers/model/GenderResponse.dart';
import 'package:jakel_base/restapi/customers/model/MemberGroupResponse.dart';
import 'package:jakel_base/restapi/customers/model/MembershipResponse.dart';

abstract class CustomerApi {
  Future<CustomersResponse> getCustomers(int pageNo, int perPage);

  Future<GenderResponse> getGenders();

  Future<CustomerTypesResponse> getCustomerTypes();

  Future<CustomerRaceResponse> getRaces();

  Future<CustomerTitlesResponse> getTitles();

  Future<CustomersResponse> createCustomer(CreateCustomerRequest request);

  Future<CustomersResponse> searchCustomer(String search);

  Future<bool> updateCustomer(int customerId, CreateCustomerRequest request);

  Future<MembershipResponse> getMembershipDetails();

  Future<CustomersResponse> getCustomerDetail(int customerId);

  Future<CustomerDetailsResponse> getCustomerDetailById(int customerId);

  Future<MemberGroupResponse> getMemberGroup();
}
