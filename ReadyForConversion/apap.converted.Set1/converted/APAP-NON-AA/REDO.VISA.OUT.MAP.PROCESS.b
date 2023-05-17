SUBROUTINE REDO.VISA.OUT.MAP.PROCESS
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :SUDHARSANAN S
*  Program   Name    :REDO.VISA.OUT.MAP.PROCESS
***********************************************************************************
*Description:  This is process routine for param table REDO.VISA.OUT.MAP
*****************************************************************************
*linked with: REDO.VISA.OUT.MAP.PROCESS
*In parameter: NA
*Out parameter: NA
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*30.12.2010   SUDHARSANAN S  ODR-2010-08-0469  INITIAL CREATION
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.REDO.VISA.OUT.MAP
    $INSERT I_F.REDO.VISA.OUTGOING
    $INSERT I_F.ATM.REVERSAL

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------
PROCESS:
*-----------------
*Update the field position value

    Y.FIELD.NAME = R.NEW(V.OUT.MAP.FIELD.NAME)
    CHANGE @VM TO @FM IN Y.FIELD.NAME
    FIELD.CNT = DCOUNT(Y.FIELD.NAME,@FM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE FIELD.CNT
        Y.FIELD.VALUE = Y.FIELD.NAME<Y.VAR1>

        IF Y.FIELD.VALUE THEN
            LOCATE Y.FIELD.VALUE IN R.SS.REDO.VISA.OUTGOING<SSL.SYS.FIELD.NAME,1> SETTING POS1 THEN
                R.NEW(V.OUT.MAP.FIELD.POS)<1,Y.VAR1> = R.SS.REDO.VISA.OUTGOING<SSL.SYS.FIELD.NO,POS1>
            END ELSE
                AF=V.OUT.MAP.FIELD.NAME
                AV=Y.VAR1
                ETEXT='EB-NOT.VALID.FIELD':@FM:Y.FIELD.VALUE
                CALL STORE.END.ERROR
            END
        END

        Y.ATM.REV.FIELD.VALUE =R.NEW(V.OUT.MAP.ATM.REV.FIELD)<1,Y.VAR1>
        IF Y.ATM.REV.FIELD.VALUE THEN
            LOCATE Y.ATM.REV.FIELD.VALUE IN R.SS.ATM.REVERSAL<SSL.SYS.FIELD.NAME,1> SETTING POS2 THEN
                R.NEW(V.OUT.MAP.ATM.REV.POS)<1,Y.VAR1> = R.SS.ATM.REVERSAL<SSL.SYS.FIELD.NO,POS2>
            END ELSE
                AF=V.OUT.MAP.ATM.REV.FIELD
                AV=Y.VAR1
                ETEXT='EB-NOT.VALID.FIELD':@FM:Y.ATM.REV.FIELD.VALUE
                CALL STORE.END.ERROR
            END
        END
        Y.VAR1 += 1
    REPEAT
RETURN
*-----------------
INIT:
*-----------------
    R.SS.REDO.VISA.OUTGOING = ''
    R.SS.ATM.REVERSAL = ''
    POS1 = ''
    POS2 = ''

    CALL GET.STANDARD.SELECTION.DETS('REDO.VISA.OUTGOING',R.SS.REDO.VISA.OUTGOING)
    CALL GET.STANDARD.SELECTION.DETS('ATM.REVERSAL',R.SS.ATM.REVERSAL)

RETURN
*-------------------------------------------------------------------
END
