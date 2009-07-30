/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace Iko.Report {
  public int n_errors = 0;

  public void error(SourceReference? src, string message) {
    n_errors++;
    if(src != null)
      stderr.printf("%s:", src.to_string());
    stderr.printf("%s\n", message);
  }
}
