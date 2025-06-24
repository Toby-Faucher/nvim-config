vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*.py",
  callback = function()
    vim.schedule(function()
      local buf = vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local filepath = vim.fn.expand("%:p")
      
      if filepath:lower():find("leetcode") and #lines == 1 and lines[1] == "" then
        local filename = vim.fn.expand("%:t:r")
        local func_name = filename:gsub("([A-Z])", "_%1"):lower():gsub("^_", "")
        local template = {
          "from typing import List, Dict, Set, Tuple, Optional, Union, Any",
          "from collections import defaultdict, deque, Counter, OrderedDict",
          "from heapq import heappush, heappop, heapify, nlargest, nsmallest",
          "from bisect import bisect_left, bisect_right, insort",
          "from itertools import permutations, combinations, product, accumulate, chain",
          "from functools import lru_cache, reduce, cmp_to_key",
          "from math import ceil, floor, sqrt, gcd, lcm, inf, log, log2, log10",
          "import re",
          "import sys",
          "",
          "class Solution:",
          string.format("    def %s(self, params) -> ReturnType:", func_name),
          "        pass",
          "",
          'if __name__ == "__main__":',
          "    sol = Solution()",
          string.format("    # print(sol.%s(args))", func_name),
        }
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, template)
        vim.cmd("normal! 11G$") -- Go to method definition line
      end
    end)
  end,
})
