//==============================================================================
// cl_dynamic_array.svh (v0.1.0)
//
// The MIT License (MIT)
//
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//==============================================================================

`ifndef CL_DYNAMIC_ARRAY_SVH
`define CL_DYNAMIC_ARRAY_SVH

//------------------------------------------------------------------------------
// Class: dynamic_array
//   A parameterized class that manages a dynamic array. The default type is
//   *bit*. *WIDTH* is used to specify the size of an unpacked array only if the
//   dynamic array is converted to/from the unpacked array.
//------------------------------------------------------------------------------

virtual class dynamic_array #( type T = bit, int WIDTH = 1 );

   local static formatter#(T) default_fmtr = hex_formatter#(T)::get_instance();
   local static comparator#(T) default_cmp = comparator#(T)::get_instance();

   //---------------------------------------------------------------------------
   // Typedef: ua_type
   //   The shorthand of the unpacked array of type *T*.
   //---------------------------------------------------------------------------

   typedef T ua_type[WIDTH];

   //---------------------------------------------------------------------------
   // Typedef: da_type
   //   The shorthand of the dynamic array of type *T*.
   //---------------------------------------------------------------------------

   typedef T da_type[];

   //---------------------------------------------------------------------------
   // Typedef: q_type
   //   The shorthand of the queue of type *T*.
   //---------------------------------------------------------------------------

   typedef T q_type[$];

   //---------------------------------------------------------------------------
   // Function: from_unpacked_array
   //   Converts an unpacked array of type *T* to the dynamic array of the same
   //   type.
   //
   // Arguments:
   //   ua      - An input unpacked array.
   //   reverse - (OPTIONAL) If 1, the item at index 0 of the unpacked array
   //             occupies the index WIDTH-1 of the dynamic array. If 0, the
   //             item at index 0 of the unpacked array occupies the index 0 of
   //             the dynamic array. The default is 0.
   //             
   // Returns:
   //   The dynamic array converted from *ua*.
   //
   // Examples:
   // | bit ua[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // same as ua[0:7]
   // | assert( dynamic_array#(bit,8)::from_unpacked_array( ua                ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( dynamic_array#(bit,8)::from_unpacked_array( ua, .reverse( 1 ) ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   //---------------------------------------------------------------------------

   static function da_type from_unpacked_array( const ref ua_type ua,
						input bit reverse = 0 );
      from_unpacked_array = new[ $size( ua ) ];
      common_array#( T, WIDTH, da_type )::ua_to_a( ua, from_unpacked_array,
						   reverse );
   endfunction: from_unpacked_array

   //---------------------------------------------------------------------------
   // Function: to_unpacked_array
   //---------------------------------------------------------------------------

   static function ua_type to_unpacked_array( const ref da_type da,
					      input bit reverse = 0 );
      common_array#( T, WIDTH, ua_type )::da_to_a( da, to_unpacked_array, 
						   reverse );
   endfunction: to_unpacked_array

   //---------------------------------------------------------------------------
   // Function: from_queue
   //   Converts a queue of type *T* to the dynamic array of the same type.
   //
   // Arguments:
   //   q       - An input queue.
   //   reverse - (OPTIONAL) If 1, the item at index 0 of the queue
   //             occupies the index WIDTH-1 of the dynamic array. If 0, the
   //             item at index 0 of the queue occupies the index 0 of
   //             the dynamic array. The default is 0.
   //
   // Returns:
   //   The dynamic array converted from *q*.
   //
   // Examples:
   // | bit q[$] = '{ 0, 0, 0, 1, 1, 0, 1, 1 };
   // | assert( dynamic_array#(bit)::from_queue( ua                ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( dynamic_array#(bit)::from_queue( ua, .reverse( 1 ) ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   //---------------------------------------------------------------------------

   static function da_type from_queue( const ref q_type q,
				       input bit reverse = 0 );
      from_queue = new[ q.size() ];
      common_array#( T, WIDTH, da_type )::q_to_a( q, from_queue, reverse );
   endfunction: from_queue

   //---------------------------------------------------------------------------
   // Function: to_queue
   //   Converts a dynamic array of type *T* to the queue of the same type.
   //
   // Arguments:
   //   da      - An input dynamic array.
   //   reverse - (OPTIONAL) If 1, the item at index 0 of the dynamic array
   //             occupies the index WIDTH-1 of the queue. If 0, the item at
   //             index 0 of the dynamic array occupies the index 0 of the
   //             queue. The default is 0.
   //
   // Returns:
   //   The queue converted from *da*.
   //
   // Examples:
   // | bit da[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( dynamic_array#(bit)::to_queue( da                ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( dynamic_array#(bit)::to_queue( da, .reverse( 1 ) ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   //---------------------------------------------------------------------------

   static function q_type to_queue( const ref da_type da,
				    input bit reverse = 0 );
      common_array#( T, WIDTH, da_type )::a_to_q( da, to_queue, reverse );
   endfunction: to_queue

   //---------------------------------------------------------------------------
   // Function: init
   //---------------------------------------------------------------------------

   static function void init( ref da_type da, input T val );
      common_array#( T, WIDTH, da_type )::init( da, val );
   endfunction: init

   //---------------------------------------------------------------------------
   // Function: reverse
   //   Returns a copy of the given dynamic array with the elements in reverse
   //   order.
   //
   // Argument:
   //   da - An input dynamic array.
   //
   // Returns:
   //   A copy of *da* with the elements in reverse order.
   //
   // Example:
   // | bit da[];
   // | da = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( dynamic_array#(bit)::reverse( da ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   //---------------------------------------------------------------------------

   static function void reverse( ref da_type da );
      common_array#( T, WIDTH, da_type )::reverse( da );
   endfunction: reverse

   //---------------------------------------------------------------------------
   // Function: split
   //   Splits the specified data stream into two data streams.
   //
   // Arguments:
   //   ds  - Input data stream.
   //   ds0 - Output data stream with data elements at even location of the
   //         input data stream.
   //   ds1 - Output data stream with data elements at odd location of the
   //         input data stream.
   //   pad - (OPTIONAL) If the size of input data stream is odd and *pad* is 1,
   //         the size of *ds1* is extended to be the same size as *ds0*. If 0,
   //         no padding element is added. The default is 0.
   //
   // Examples:
   // | ds=[0][1][2][3][4] --> ds0=[0][2][4] ds1=[1][3]    (pad=0)
   // | ds=[0][1][2][3][4] --> ds0=[0][2][4] ds1=[1][3][ ] (pad=1)
   //---------------------------------------------------------------------------

   static function void split( da_type da,
			       ref da_type da0,
			       ref da_type da1,
			       input bit pad = 0 );
      int da_size = da.size();

      if ( da_size % 2 == 0 ) begin // even
	 da0 = new[ da_size / 2 ];
	 da1 = new[ da_size / 2 ];
      end else if ( pad ) begin
	 da0 = new[ ( da_size + 1 ) / 2 ];
	 da1 = new[ ( da_size + 1 ) / 2 ];
      end else begin
	 da0 = new[ ( da_size + 1 ) / 2 ];
	 da1 = new[ da_size / 2 ];
      end
      for ( int i = 0; i < da.size(); i += 2 ) da0[i/2] = da[i];
      for ( int i = 1; i < da.size(); i += 2 ) da1[i/2] = da[i];
   endfunction: split      

   //---------------------------------------------------------------------------
   // Function: merge
   //---------------------------------------------------------------------------

   static function da_type merge( da_type da0,
				  da_type da1,
				  bit truncate = 0 );
      int da0_size = da0.size();
      int da1_size = da1.size();

      if ( da0_size == da1_size ) begin
	 merge = new[ da0_size + da1_size ];
	 for ( int i = 0; i < da0_size; i++ ) begin
	    merge[i*2  ] = da0[i];
	    merge[i*2+1] = da1[i];
	 end
      end else if ( da0_size < da1_size ) begin
	 if ( truncate ) begin
	    merge = new[ da0_size * 2 ];
	    for ( int i = 0; i < da0_size; i++ ) begin
	       merge[i*2  ] = da0[i];
	       merge[i*2+1] = da1[i];
	    end
	 end else begin
	    merge = new[ da0_size + da1_size ];
	    for ( int i = 0; i < da0_size; i++ ) begin
	       merge[i*2  ] = da0[i];
	       merge[i*2+1] = da1[i];
	    end
	    for ( int i = 0; i < ( da1_size - da0_size ); i++ )
	      merge[ da0_size * 2 + i ] = da1[ da0_size + i ];
	 end // else: !if( truncate )
      end else begin // da0_size > da1_size
	 if ( truncate ) begin
	    merge = new[ da1_size * 2 ];
	    for ( int i = 0; i < da1_size; i++ ) begin
	       merge[i*2  ] = da0[i];
	       merge[i*2+1] = da1[i];
	    end
	 end else begin
	    merge = new[ da0_size + da1_size ];
	    for ( int i = 0; i < da1_size; i++ ) begin
	       merge[i*2  ] = da0[i];
	       merge[i*2+1] = da1[i];
	    end
	    for ( int i = 0; i < ( da0_size - da1_size ); i++ )
	      merge[ da1_size * 2 + i ] = da1[ da1_size + i ];
	 end // else: !if( truncate )
      end
   endfunction: merge

   //---------------------------------------------------------------------------
   // Function: concat
   //   Concatenate the specified two dynamic arrays.
   //
   // Arguments:
   //   da0 - Input dynamic array.
   //   da1 - Another dynamic array.
   //
   // Returns:
   //   A new dynamic array by concatenating *da0* and *da1*.
   //---------------------------------------------------------------------------

   static function da_type concat( da_type da0,
				   da_type da1 );
      int da0_size = da0.size();
      int da1_size = da1.size();
      da_type da = new[ da0_size + da1_size ] ( da0 );

      for ( int i = 0; i < da1_size; i++ )
	da[ da0_size + i ] = da1[i];
      return da;
   endfunction: concat

   //---------------------------------------------------------------------------
   // Function: extract
   //---------------------------------------------------------------------------

   static function da_type extract( da_type da,
				    int from_index = 0,
				    int to_index = -1 );
      util::normalize( da.size(), from_index, to_index );
      extract = new[ to_index - from_index + 1 ];
      for ( int i = from_index; i <= to_index; i++ )
	extract[ i - from_index ] = da[i];
   endfunction: extract

   //---------------------------------------------------------------------------
   // Function: append
   //   Appends the specified element to the specified dynamic array.
   //
   // Arguments:
   //   da - The input dynamic array.
   //   e  - An element to append.
   //
   // Returns:
   //   The copy of *da* appended with *e*.
   //---------------------------------------------------------------------------

   static function da_type append( da_type da, T e );
      int da_size = da.size();
      
      append = new[ da_size + 1 ]( da );
      append[da_size] = e;
   endfunction: append

   //---------------------------------------------------------------------------
   // Function: compare
   //   Compares two dynamic arrays.
   //
   // Arguments:
   //   da1         - A dynamic array.
   //   da2         - Another dynamic array to compare with *da1*.
   //   from_index1 - (OPTIONAL) The first index of the *da1* to compare.
   //                 If negative, count from the last.  For example, if the
   //                 *from_index1* is -9, compare from the ninth element
   //                 (inclusive) from the last.  The default value is 0.
   //   to_index1   - (OPTIONAL) The last index of the *da1* to compare.
   //                 If negative, count from the last.  For example, if the
   //                 *from_index1* is -3, compare to the third element
   //                 (inclusive) from the last.  The default value is -1
   //                 (compare to the last element).
   //   from_index2 - (OPTIONAL) The first index of the *da2* to compare.
   //                 If negative, count from the last.  For example, if the
   //                 *from_index2* is -9, compare from the ninth element
   //                 (inclusive) from the last.  The default value is 0.
   //   to_index2   - (OPTIONAL) The last index of the *da2* to compare.
   //                 If negative, count from the last.  For example, if the
   //                 *from_index2* is -3, compare to the third element
   //                 (inclusive) from the last.  The default value is -1
   //                 (compare to the last element).
   //   cmp         - (OPTIONAL) Compare strategy. If not specified or null, 
   //                 *comparator#(T)* is used. The default is null.
   //
   // Returns:
   //   If two dynamic arrays contain the same data, 1 is returned. Otherwise, 
   //   0 is returned.
   //
   // Examples:
   // | bit da1[];
   // | bit da2[];
   // | da1 = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | da2 = new[8]( '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   // | assert( dynamic_array#(bit)::compare( da1, da2 ) == 0 );
   // | assert( dynamic_array#(bit)::compare( da1, da2, .from_index1( 2 ), .to_index1( 5 ), 
   // |                                                 .from_index2( 2 ), .to_index2( 5 ) ) == 1 );
   //---------------------------------------------------------------------------

   static function bit compare( const ref da_type da1,
				const ref da_type da2,
				input int from_index1 = 0, 
				int to_index1   = -1,
				int from_index2 = 0, 
				int to_index2   = -1,
				comparator#(T) cmp = null );
      return common_array#( T, WIDTH, da_type )::
	compare( da1, da2, from_index1, to_index1, from_index2, to_index2, cmp );
   endfunction: compare

   //---------------------------------------------------------------------------
   // Function: clone
   //   Returns a copy of the given dynamic array.
   //
   // Argument:
   //   da - A dynamic array to be cloned.
   //
   // Returns:
   //   A copy of *da*.
   //
   // Example:
   // | bit da[];
   // | da = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( dynamic_array#(bit)::clone( da ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   //---------------------------------------------------------------------------

   static function da_type clone( da_type da );
      clone = da; // same as new[ da.size() ]( da ); see LRM7.6
   endfunction: clone

   //---------------------------------------------------------------------------
   // Function: to_string
   //   Returns a string representation of this dynamic array.
   //
   // Argument:
   //   da   - An input dynamic array.
   //   fmtr - (OPTIONAL) An object that provides a function to convert the
   //          element of type *T* to a string.
   //
   // Returns:
   //   A string that represents this dynamic array.
   //---------------------------------------------------------------------------

   static function string to_string( const ref da_type da,
				     input string separator = " ",
				     formatter#(T) fmtr = null );
      return common_array#( T, WIDTH, da_type )::to_string( da, separator, fmtr );
   endfunction: to_string

endclass: dynamic_array

`endif //  `ifndef CL_DYNAMIC_ARRAY_SVH

//==============================================================================
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
