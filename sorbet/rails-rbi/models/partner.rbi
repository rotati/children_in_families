# This is an autogenerated file for dynamic methods in Partner
# Please rerun rake rails_rbi:models to regenerate.
# typed: strong

class Partner::ActiveRecord_Relation < ActiveRecord::Relation
  include Partner::ModelRelationShared
  extend T::Generic
  Elem = type_member(fixed: Partner)
end

class Partner::ActiveRecord_Associations_CollectionProxy < ActiveRecord::Associations::CollectionProxy
  include Partner::ModelRelationShared
  extend T::Generic
  Elem = type_member(fixed: Partner)
end

class Partner < ActiveRecord::Base
  extend T::Sig
  extend T::Generic
  extend Partner::ModelRelationShared
  include Partner::InstanceMethods
  Elem = type_template(fixed: Partner)
end

module Partner::InstanceMethods
  extend T::Sig

  sig { returns(T.nilable(String)) }
  def address(); end

  sig { params(value: T.nilable(String)).void }
  def address=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def address?(*args); end

  sig { returns(T.nilable(String)) }
  def affiliation(); end

  sig { params(value: T.nilable(String)).void }
  def affiliation=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def affiliation?(*args); end

  sig { returns(T.nilable(String)) }
  def archive_organization_type(); end

  sig { params(value: T.nilable(String)).void }
  def archive_organization_type=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def archive_organization_type?(*args); end

  sig { returns(T.nilable(String)) }
  def background(); end

  sig { params(value: T.nilable(String)).void }
  def background=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def background?(*args); end

  sig { returns(T.nilable(Integer)) }
  def cases_count(); end

  sig { params(value: T.nilable(Integer)).void }
  def cases_count=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def cases_count?(*args); end

  sig { returns(T.nilable(String)) }
  def contact_person_email(); end

  sig { params(value: T.nilable(String)).void }
  def contact_person_email=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def contact_person_email?(*args); end

  sig { returns(T.nilable(String)) }
  def contact_person_mobile(); end

  sig { params(value: T.nilable(String)).void }
  def contact_person_mobile=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def contact_person_mobile?(*args); end

  sig { returns(T.nilable(String)) }
  def contact_person_name(); end

  sig { params(value: T.nilable(String)).void }
  def contact_person_name=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def contact_person_name?(*args); end

  sig { returns(T.nilable(T.untyped)) }
  def created_at(); end

  sig { params(value: T.nilable(T.untyped)).void }
  def created_at=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def created_at?(*args); end

  sig { returns(T.nilable(String)) }
  def engagement(); end

  sig { params(value: T.nilable(String)).void }
  def engagement=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def engagement?(*args); end

  sig { returns(Integer) }
  def id(); end

  sig { params(value: Integer).void }
  def id=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def id?(*args); end

  sig { returns(T.nilable(String)) }
  def name(); end

  sig { params(value: T.nilable(String)).void }
  def name=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def name?(*args); end

  sig { returns(T.nilable(Integer)) }
  def organization_type_id(); end

  sig { params(value: T.nilable(Integer)).void }
  def organization_type_id=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def organization_type_id?(*args); end

  sig { returns(T.nilable(Integer)) }
  def province_id(); end

  sig { params(value: T.nilable(Integer)).void }
  def province_id=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def province_id?(*args); end

  sig { returns(T.nilable(Date)) }
  def start_date(); end

  sig { params(value: T.nilable(Date)).void }
  def start_date=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def start_date?(*args); end

  sig { returns(T.nilable(T.untyped)) }
  def updated_at(); end

  sig { params(value: T.nilable(T.untyped)).void }
  def updated_at=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def updated_at?(*args); end

end

class Partner
  extend T::Sig

  sig { returns(::Case::ActiveRecord_Associations_CollectionProxy) }
  def cases(); end

  sig { params(value: T.any(T::Array[::Case], ::Case::ActiveRecord_Associations_CollectionProxy)).void }
  def cases=(value); end

  sig { returns(::CustomFieldProperty::ActiveRecord_Associations_CollectionProxy) }
  def custom_field_properties(); end

  sig { params(value: T.any(T::Array[::CustomFieldProperty], ::CustomFieldProperty::ActiveRecord_Associations_CollectionProxy)).void }
  def custom_field_properties=(value); end

  sig { returns(::CustomField::ActiveRecord_Associations_CollectionProxy) }
  def custom_fields(); end

  sig { params(value: T.any(T::Array[::CustomField], ::CustomField::ActiveRecord_Associations_CollectionProxy)).void }
  def custom_fields=(value); end

  sig { returns(T.nilable(::OrganizationType)) }
  def organization_type(); end

  sig { params(value: T.nilable(::OrganizationType)).void }
  def organization_type=(value); end

  sig { returns(T.nilable(::Province)) }
  def province(); end

  sig { params(value: T.nilable(::Province)).void }
  def province=(value); end

  sig { returns(::PaperTrail::Version::ActiveRecord_Associations_CollectionProxy) }
  def versions(); end

  sig { params(value: T.any(T::Array[::PaperTrail::Version], ::PaperTrail::Version::ActiveRecord_Associations_CollectionProxy)).void }
  def versions=(value); end

end

module Partner::ModelRelationShared
  extend T::Sig

  sig { returns(Partner::ActiveRecord_Relation) }
  def all(); end

  sig { params(block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(Partner::ActiveRecord_Relation) }
  def NGO(*args); end

  sig { params(args: T.untyped).returns(Partner::ActiveRecord_Relation) }
  def address_like(*args); end

  sig { params(args: T.untyped).returns(Partner::ActiveRecord_Relation) }
  def affiliation_like(*args); end

  sig { params(args: T.untyped).returns(Partner::ActiveRecord_Relation) }
  def background_like(*args); end

  sig { params(args: T.untyped).returns(Partner::ActiveRecord_Relation) }
  def church(*args); end

  sig { params(args: T.untyped).returns(Partner::ActiveRecord_Relation) }
  def contact_person_email_like(*args); end

  sig { params(args: T.untyped).returns(Partner::ActiveRecord_Relation) }
  def contact_person_mobile_like(*args); end

  sig { params(args: T.untyped).returns(Partner::ActiveRecord_Relation) }
  def contact_person_name_like(*args); end

  sig { params(args: T.untyped).returns(Partner::ActiveRecord_Relation) }
  def engagement_like(*args); end

  sig { params(args: T.untyped).returns(Partner::ActiveRecord_Relation) }
  def local_goverment(*args); end

  sig { params(args: T.untyped).returns(Partner::ActiveRecord_Relation) }
  def name_like(*args); end

  sig { params(args: T.untyped).returns(Partner::ActiveRecord_Relation) }
  def organization_type_are(*args); end

  sig { params(args: T.untyped).returns(Partner::ActiveRecord_Relation) }
  def province_are(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def select(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def order(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def reorder(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def group(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def limit(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def offset(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def joins(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def where(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def rewhere(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def preload(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def eager_load(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def includes(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def from(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def lock(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def readonly(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def or(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def having(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def create_with(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def distinct(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def references(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def none(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def unscope(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Partner::ActiveRecord_Relation) }
  def except(*args, &block); end

end