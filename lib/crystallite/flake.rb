require 'transformatrix'

module Crystallite
	class Flake
		include Math

		attr :points
		attr :size
		attr :axes

		attr :new_points

		attr :div_alpha, :div_radius
		attr :sector_alpha
		attr :sector_point_count

		def initialize size, min_points, max_points, axes
			@points = []
			@size = size
			@axes = axes

			@min_points = min_points
			@max_points = max_points
			
			# @sector_points = []

			@div_alpha = 2
			@div_radius = 5

			@sector_alpha = PI / axes
			
			@sector_point_count = rand(min_points..max_points)
			@sector_point_count /= axes
			@sector_point_count /= 4

			generate_points
		end

		def generate
			if axes == 0
				random_generate
			elsif axes == 1
				nil
			else
				nil
			end
				
		end

		def p_debug
			puts "@points: #{@points}"
			puts ""
			puts "@new_points: #{@new_points}"
			puts ""
		end

		def generate_points
			@new_points = initial_points
			
			@new_points.sort_by! do |point|
				point_acos point
			end

			p_debug

			@new_points += reflect_points(@new_points, [1,0])
			@points += @new_points

			p_debug

			(@axes-1).times do |i|
				angle = @sector_alpha + i*@sector_alpha
				@new_points = reflect_points(@new_points, [cos(angle), sin(angle)])
				@points += @new_points
			end

			p_debug

			@points.each do |point|
				point[0] += @size/2
				point[1] += @size/2
			end
		end


		def sort_points!
			@points.sort_by! do |p|
				point_acos(p)
			end
		end

		def points
			@points
		end


		private

		# Point modifiers

		def point_acos point
			# point[1] > 0 ? acos(point[0]/(size*2)) : 2*PI - acos(point[0]/(size*2))

			ret = acos(point[0]/Vector[point[0],point[1]].r)
			if ret < 0 then raise "Small" end
			if ret > PI/2 then raise "Large" end
			-ret
		end

		def point_radius point
			Vector[point[0],point[1]].r
		end

		#
		# Pointlist generators
		#

		def initial_points
			ret_points = []

			sector_point_count.times do |i|
				radius = @size / 2
				radius /= rand(1..@div_radius)

				alpha = sector_alpha / div_alpha * rand(0..@div_alpha)
				
				x = radius * cos(alpha) 
				y = radius * sin(alpha)
				
				# p "alpha / PI: #{alpha / PI}, radius: #{radius}, point: [#{x}, #{y}]"

				ret_points.push([x,y])
			end
			ret_points
		end

		def reflect_points point_list, axis
			ret_points = []
			point_list.reverse_each do |point|
				ret_points.push(TMatrix.reflection(axis[0], axis[1]) * point)
			end
			ret_points
		end

		def rotate_points point_list, angle
			ret_points = []
			point_list.each do |point|
				ret_points.push (TMatrix.rotation(angle) * point)
			end
			ret_points
		end

		
	end
end