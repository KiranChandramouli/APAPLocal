* @ValidationCode : Mjo0MDk1NDExMzY6Q3AxMjUyOjE2ODQ4NDIxNDg1MDU6SVRTUzotMTotMTozNTc6MTpmYWxzZTpOL0E6UjIyX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 357
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VAU.MONITOR.DEMOG.CHANGE

*-----------------------------------------------------------------------------
* Primary Purpose: Authorisation routine linked to application CUSTOMER
* as VERSION CONTROL to feed queue REDO.MONITOR.QUEUE
* in order to meet Monitor Interface requirement (C7)
*-----------------------------------------------------------------------------
* Modification History:
*
* 04/09/10 - Cesar Yepez
* New Development
*
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           VM TO @VM, = TO EQ
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION         CALL routine format modified
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.MONITOR.PARAMETER
    $INSERT I_TSS.COMMON
    $USING APAP.REDOCHNLS
    
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN
*-----------------------------------------------------------------------------------

PROCESS:
*DEBUG
    CALL F.READ(FN.MONITOR.PARAMETER,Y.APPLICATION, R.RECORD,F.MONITOR.PARAMETER,Y.ERR.PARAM)
    IF NOT(Y.ERR.PARAM) THEN
        Y.FIELD.MAP.REF = R.RECORD<REDO.MON.PARAM.FIELD.MAP.REF>
        IF Y.FIELD.MAP.REF NE '' THEN
            BEGIN CASE
                CASE R.NEW(EB.CUS.CURR.NO) EQ '1'
                    GOSUB SEND.QUEUE
                CASE OTHERWISE
                    Y.NUM.FIELDS = DCOUNT(R.RECORD<REDO.MON.PARAM.FIELD.NAME>,@VM)
                    FOR Y.COUNT = 1 TO Y.NUM.FIELDS
                        Y.MV.NO = '' ; Y.LOC.POS = ''; Y.FIELD.NO = ''; Y.FIELD.NAME = ''
                        Y.LOCREF.FLAG = ''; Y.CHANGE.FLAG = ''

* Get position field
                        Y.FIELD.NAME = R.RECORD<REDO.MON.PARAM.FIELD.NAME,Y.COUNT>
                        Y.FIELD.NO = Y.FIELD.NAME
                        CALL EB.FIND.FIELD.NO(Y.APPLICATION,Y.FIELD.NO)
                        IF Y.FIELD.NO EQ '' THEN
                            CALL GET.LOC.REF(Y.APPLICATION,Y.FIELD.NAME, Y.LOC.POS)

                            IF Y.LOC.POS EQ '' THEN
                                ERR.MSG = 'INVALID FIELD ' : Y.FIELD.NAME : ' IN MONITOR PARAMETER TABLE'
                                ERR.TYPE = 'WARNING'
                                GOSUB LOG.ERROR
                            END ELSE
                                Y.FIELD.NO = EB.CUS.LOCAL.REF
                                Y.LOCREF.FLAG = '1'
                                Y.MV.NO = Y.LOC.POS
                            END
                        END

* Analyse if the field has changed
                        IF Y.FIELD.NO NE '' THEN
                            GOSUB ANALYSE.CHANGE
                            IF Y.CHANGE.FLAG THEN
                                Y.COUNT = Y.NUM.FIELDS + 1
                            END
                        END
                    NEXT Y.COUNT
                    IF Y.CHANGE.FLAG THEN
                        GOSUB SEND.QUEUE
                    END
            END CASE
        END
    END

RETURN
*-----------------------------------------------------------------------------------
SEND.QUEUE:
*DEBUG
    P.REC.ID = ID.NEW
    P.MAP.ID = Y.FIELD.MAP.REF
    P.FUNCT = V$FUNCTION
    P.OPERATOR = OPERATOR
    P.COMPANY = ID.COMPANY
    P.APP = APPLICATION
    P.OBJ = APPLICATION : PGM.VERSION
    MATBUILD P.REC.NEW FROM R.NEW
    MATBUILD P.REC.OLD FROM R.OLD
    P.ACC.NEW = ''
    P.ACC.OLD = ''
    O.ERR = ''


    CALL APAP.TAM.redoMonPostMapQueue(P.REC.ID, P.MAP.ID, P.FUNCT, P.OPERATOR, P.COMPANY, P.APP, P.OBJ, P.REC.OLD, P.REC.NEW, P.ACC.OLD, P.ACC.NEW, O.ERR) ;*MANUAL R22 CODE CONVERSION

    IF O.ERR THEN
        ERR.MSG = 'ERROR SENDING MAPPING QUEUE. TXN: ' : ID.NEW
        ERR.TYPE = 'ERROR'
        GOSUB LOG.ERROR
    END

RETURN
*-----------------------------------------------------------------------------------
ANALYSE.CHANGE:
    Y.CHANGE.FLAG = ''
    BEGIN CASE
        CASE Y.LOCREF.FLAG EQ '1'
            Y.OLD.VALUE = R.OLD(Y.FIELD.NO)<1,Y.MV.NO,1>
            Y.NEW.VALUE = R.NEW(Y.FIELD.NO)<1,Y.MV.NO,1>
        CASE OTHERWISE
            Y.OLD.VALUE = R.OLD(Y.FIELD.NO)
            Y.NEW.VALUE = R.NEW(Y.FIELD.NO)
    END CASE

    Y.CHANGE.FLAG = Y.OLD.VALUE NE Y.NEW.VALUE

RETURN
*-----------------------------------------------------------------------------------
LOG.ERROR:
* Register error in the fault log

    INT.CODE = Y.INTERF.ID
    INT.TYPE = 'ONLINE'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = 'T24'
    INFO.DE = 'T24'
    ID.PROC = ID.NEW
    MON.TP = ''
    DESC = ERR.MSG
    REC.CON = Y.FIELD.MAP.REF
    EX.USER = OPERATOR
    EX.PC = IP.ADDRESS

    BEGIN CASE
        CASE ERR.TYPE EQ 'WARNING'
            MON.TP = 05
        CASE ERR.TYPE EQ 'ERROR'
            MON.TP = 08
    END CASE


    CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE, INT.TYPE, BAT.NO, BAT.TOT, INFO.OR, INFO.DE, ID.PROC, MON.TP, DESC, REC.CON, EX.USER, EX.PC);*MANUAL R22 CODE CONVERSION
RETURN
*-----------------------------------------------------------------------------------

*//////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E P R O C E S S S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////////*
INITIALISE:
    PROCESS.GOAHEAD = 1
    Y.APPLICATION = APPLICATION
    Y.FIELD.MAP.REF = ''
    IP.ADDRESS = TSS$CLIENTIP
    Y.INTERF.ID = 'MON001'

RETURN
*-----------------------------------------------------------------------------------

OPEN.FILES:

    FN.MONITOR.PARAMETER = 'F.REDO.MONITOR.PARAMETER'
    F.MONITOR.PARAMETER = ''
    CALL OPF(FN.MONITOR.PARAMETER,F.MONITOR.PARAMETER)

RETURN

*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:

RETURN
*-----------------------------------------------------------------------------------

END
