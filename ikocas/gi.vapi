/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using GLib;

[CCode (cprefix = "GI", lower_case_cprefix = "g_i", cheader_filename = "gi-fixes.h")]
namespace GI {

	[CCode (cprefix = "G_IREPOSITORY_ERROR_")]
	public errordomain RepositoryError {
		TYPELIB_NOT_FOUND,
		NAMESPACE_MISMATCH,
		NAMESPACE_VERSION_CONFLICT,
		LIBRARY_NOT_FOUND
	}

	[CCode (cname="int", cprefix = "G_IREPOSITORY_LOAD_FLAG_")]
	public enum RepositoryLoadFlags {
		LAZY
	}

	[CCode (ref_function = "", unref_function = "")]
	public class Repository {
		public static unowned Repository get_default ();
		public unowned string load_typelib (Typelib typelib, RepositoryLoadFlags flags) throws RepositoryError;
		public BaseInfo? find_by_name (string namespace_, string name);
	}

	[Compact]
	[CCode (cname = "GTypelib", cprefix = "g_typelib_", free_function = "")]
	public class Typelib {
		public static Typelib new_from_mapped_file (owned MappedFile mfile) throws RepositoryError;
	}

	[CCode (cprefix = "GI_INFO_TYPE_")]
	public enum InfoType {
		FUNCTION
	}

	[Compact]
	[CCode (cprefix = "g_base_info_", ref_function = "g_base_info_ref", unref_function = "g_base_info_unref")]
	public class BaseInfo {
		public InfoType get_type ();
	}

	[CCode (cname = "GInvokeError", cprefix = "G_INVOKE_ERROR_")]
	public errordomain InvokeError {
		FAILED,
		SYMBOL_NOT_FOUND,
		ARGUMENT_MISMATCH
	}

	[Compact]
	[CCode (cprefix = "g_function_info_")]
	public class FunctionInfo : CallableInfo {
		public bool invoke(Argument[] ?in_args, Argument[] ?out_args, out Argument return_value) throws InvokeError;
	}

	[CCode (cname="GArgument")]
	public struct Argument {
		[CCode(cname = "v_pointer")]
		public void* @pointer;
	}

	[Compact]
	[CCode (cprefix = "g_callable_info_")]
	public class CallableInfo : BaseInfo {
	}
}
