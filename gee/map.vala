/* map.vala
 *
 * Copyright (C) 2007  Jürg Billeter
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Author:
 * 	Jürg Billeter <j@bitron.ch>
 */

/**
 * An object that maps keys to values.
 */
public interface Gee.Map<K,V> : GLib.Object {
	/**
	 * The number of items in this map.
	 */
	public abstract int size { get; }

	/**
	 * Specifies whether this map is empty.
	 */
	public abstract bool is_empty { get; }

	/**
	 * Returns the keys of this map as a read-only set.
	 *
	 * @return the keys of the map
	 */
	public abstract Set<K> get_keys ();

	/**
	 * Returns the values of this map as a read-only collection.
	 *
	 * @return the values of the map
	 */
	public abstract Collection<V> get_values ();

	/**
	 * Determines whether this map contains the specified key.
	 *
	 * @param key the key to locate in the map
	 *
	 * @return    true if key is found, false otherwise
	 */
	public abstract bool contains (K key);

	/**
	 * Returns the value of the specified key in this map.
	 *
	 * @param key the key whose value is to be retrieved
	 *
	 * @return    the value associated with the key, or null if the key
	 *            couldn't be found
	 */
	public abstract V? get (K key);

	/**
	 * Inserts a new key and value into this map.
	 *
	 * @param key   the key to insert
	 * @param value the value to associate with the key
	 */
	public abstract void set (K key, V value);

	/**
	 * Removes the specified key from this map.
	 *
	 * @param key   the key to remove from the map
	 * @param value the receiver variable for the removed value
	 *
	 * @return    true if the map has been changed, false otherwise
	 */
	public abstract bool remove (K key, out V? value = null);

	/**
	 * Removes all items from this collection. Must not be called on
	 * read-only collections.
	 */
	public abstract void clear ();

	/**
	 * Inserts all items that are contained in the input map to this map.
	 *
	 *  @param map the map which items are inserted to this map
	 */
	public abstract void set_all (Map<K,V> map);

	/**
	 * Removes all items from this map that are common to the input map 
	 * and this map.
	 *
	 *  @param map the map which common items are deleted from this map
	 */
	public abstract bool remove_all (Map<K,V> map);

	/**
	 * Returns true it this map contains all items as the input map.
	 *
	 * @param map the map which items will be compared with this map.
	 */
	public abstract bool contains_all (Map<K,V> map);

	/**
	 * Property giving access to the read-only view this map.
	 */
	public abstract Map<K,V> read_only_view { owned get; }
}

