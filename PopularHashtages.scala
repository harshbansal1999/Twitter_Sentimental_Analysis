import org.apache.spark._
import org.apache.spark.SparkContext._
import org.apache.spark.sql.SparkSession
import org.apache.log4j._

Logger.getLogger("org").setLevel(Level.ERROR)

   // Create a SparkContext using every core of the local machine
   val sc = new SparkContext("local[*]", "WordCount")

   // Read each line of my book into an RDD
   val input = sc.textFile("tweets.txt")

   // Now eliminate anything that's not a hashtag
   val hashtags = input.filter(word => word.startsWith("#"))

   // Map each hashtag to a key/value pair of (hashtag, 1) so we can count them up by adding up the values
    val hashtagKeyValues = hashtags.map(hashtag => (hashtag, 1))

    val hashtagCounts = hashtagKeyValues.reduceByKey( (x,y) => x + y)

    // Sort the results by the count values
    val sortedResults = hashtagCounts.sortByKey()

    // Print the results, flipping the (count, word) results to word: count as we go.
    for (result <- wordCountsSorted) {
      val count = result._1
      val word = result._2
      println(s"$word: $count")
    }
