/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

[CCode (cheader_filename = "gmp.h")]
namespace GMP
{
	[CCode (cname = "__mpz_struct", destroy_function = "mpz_clear")]
	public struct VarInt
	{
		[CCode (cname = "mpz_init_set_str")]
		public VarInt.string(string value, int b = 0) requires(b == 0 || b >= 2 && b <= 62);

		[CCode (cname = "mpz_init_set_si")]
		public VarInt.long(long value);

		[CCode (cname = "mpz_get_si")]
		public long get_long();

		[CCode (cname = "mpz_get_str")]
		private static string mpz_get_str(string? str, int radix, VarInt _this);

		public inline string to_string()
		{
			return mpz_get_str(null, 10, this);
		}

		[CCode (cname = "mpz_add")]
		public void add(VarInt a, VarInt b);

		[CCode (cname = "mpz_sub")]
		public void sub(VarInt a, VarInt b);

		[CCode (cname = "mpz_mul")]
		public void mul(VarInt a, VarInt b);

		[CCode (cname = "mpz_tdiv_q")]
		public void tdiv_quot(VarInt a, VarInt b);

		[CCode (cname = "mpz_tdiv_r")]
		public void tdiv_rem(VarInt a, VarInt b);

		[CCode (cname = "mpz_abs")]
		public void abs(VarInt a);

		[CCode (cname = "mpz_neg")]
		public void neg(VarInt a);

		[CCode (cname = "mpz_gcd")]
		public void gcd(VarInt a, VarInt b);

		[CCode (cname = "mpz_lcm")]
		public void lcm(VarInt a, VarInt b);

		[CCode (cname = "mpz_cmp")]
		public static int cmp(VarInt a, VarInt b);
	}
}
