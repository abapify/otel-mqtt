class ZCL_OTEL_PUBLISHER_MQTT definition
  public
  create public .

public section.

  interfaces ZIF_OTEL_STREAM .
  interfaces ZIF_OTEL_PUBLISHER .

  methods CONSTRUCTOR
    importing
      !TOPIC_NAME type STRING
      !CLIENT type ref to IF_MQTT_CLIENT .
  protected section.
private section.

  data CLIENT type ref to IF_MQTT_CLIENT .
  data TOPIC_NAME type STRING .

  methods DISCONNECT .
ENDCLASS.



CLASS ZCL_OTEL_PUBLISHER_MQTT IMPLEMENTATION.


  method CONSTRUCTOR.
    me->topic_name = topic_name.
    me->client = client.
  endmethod.


  method DISCONNECT.
    check me->client is bound.
    try.
        me->client->disconnect( ).
      catch cx_mqtt_error. " MQTT error handling class
        " not sure if we need to have handling of wrong disconnect
    endtry.
  endmethod.


  method ZIF_OTEL_STREAM~PUBLISH.

    check me->client is bound.

    try.

        data(mqtt_message) = cl_mqtt_message=>create( ).

        mqtt_message->set_binary( i_message = message->get_binary( ) ).

        me->client->publish(
          exporting
            i_topic_name = me->topic_name
            i_message    = mqtt_message
        ).
      catch cx_root.
        " ToDo exeption handling
    endtry.

  endmethod.


  method ZIF_OTEL_PUBLISHER~START.
  endmethod.


  method ZIF_OTEL_PUBLISHER~STOP.
    me->disconnect( ).
  endmethod.
ENDCLASS.
