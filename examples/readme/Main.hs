{-# LANGUAGE OverloadedStrings #-}

import Control.Concurrent
import Control.Concurrent.Async
import LightStep.HighLevel.IO (LogEntryKey (..), addLog, getEnvConfig, setTag, withSingletonLightStep, withSpan)

seriousBusinessMain :: IO ()
seriousBusinessMain = concurrently_ frontend backend
  where
    frontend =
      withSpan "RESTful API" $ do
        threadDelay 10000
        setTag "foo" "bar"
        withSpan "Kafka" $ do
          threadDelay 20000
          setTag "foo" "baz"
        threadDelay 30000
        withSpan "GraphQL" $ do
          threadDelay 40000
          setTag "foo" "quux"
          addLog Event "monkey-job"
          addLog (Custom "foo") "bar"
          withSpan "Mongodb" $ do
            threadDelay 50000
          setTag "lorem" "ipsum"
          threadDelay 60000
        withSpan "data->json" $ pure ()
        withSpan "json->yaml" $ pure ()
        withSpan "yaml->xml" $ pure ()
        withSpan "xml->protobuf" $ pure ()
        withSpan "protobuf->thrift" $ pure ()
        withSpan "thrift->base64" $ pure ()
        threadDelay 70000
    backend =
      withSpan "Background Data Science" $ do
        threadDelay 10000
        withSpan "Tensorflow" $ do
          threadDelay 100000
          setTag "learning" "deep"
        withSpan "Torch" $ do
          threadDelay 100000
          setTag "learning" "very_deep"
        withSpan "Hadoop" $ do
          threadDelay 100000
          setTag "learning" "super_deep"

main :: IO ()
main = do
  -- Construct a config from env variables
  -- - LIGHTSTEP_ACCESS_TOKEN
  -- - LIGHTSTEP_HOST (optional)
  -- - LIGHTSTEP_PORT (optional)
  -- - LIGHTSTEP_SERVICE (optional)
  Just lsConfig <- getEnvConfig
  withSingletonLightStep lsConfig seriousBusinessMain
  putStrLn "All done"
