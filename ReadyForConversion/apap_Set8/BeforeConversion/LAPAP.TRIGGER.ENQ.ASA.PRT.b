*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.TRIGGER.ENQ.ASA.PRT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_ENQUIRY.COMMON
    $INSERT BP I_F.ST.L.APAP.ASAMBLEA.VOTANTE

*Y.ENQ.OP = ""

*Y.ENQ.OP<1,1> = "LAPAP.ENQ.ASA.IMPR"

*Y.ENQ.OP<2,1> = "@ID"

*Y.ENQ.OP<3,1> = "EQ"

*Y.ENQ.OP<4,1> = ID.NEW    ;*CEDULA


*CALL ENQUIRY.DISPLAY (Y.ENQ.OP)

    TAREA ="ENQ LAPAP.ENQ.ASA.IMPR @ID EQ " : ID.NEW

    CALL EB.SET.NEW.TASK(TAREA)


END
