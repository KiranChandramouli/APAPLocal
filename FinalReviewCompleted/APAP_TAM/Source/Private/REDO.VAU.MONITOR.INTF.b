* @ValidationCode : MjotNTI1MjMzNDA6Q3AxMjUyOjE2ODM4NjY3MjcyNDc6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 May 2023 10:15:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
* Version 2 02/06/00 GLOBUS Release No. G11.0.00 29/06/00
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.VAU.MONITOR.INTF
*-----------------------------------------------------------------------------
* Modification History

*-----------------------------------------------------------------------------
* 09/03/10 - BG_100011433
* Creation: Victor Nava
* 08/09/10 - Cesar Yepez, modifications according requirement
* 23/09/17 - Gopala krishnan R, PACS00619090.
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             = TO EQ
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION          CALL routine format modified
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
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

*-----------------------------------------------------------------------------

PROCESS:
    CALL F.READ(FN.REDO.MONITOR.PARAMETER,Y.APPLICATION,R.RECORD.PARAM,F.REDO.MONITOR.PARAMETER,Y.ERR.PARAM)

    IF NOT(Y.ERR.PARAM) THEN

        Y.VERSION.NAME = APPLICATION : PGM.VERSION
        Y.VER.NAME.POS=''

        LOCATE Y.VERSION.NAME IN R.RECORD.PARAM<REDO.MON.PARAM.VERSION.NAME,1> SETTING Y.POS.MV THEN

            Y.COUNT.SV = DCOUNT(R.RECORD.PARAM<REDO.MON.PARAM.VER.MAP.REF,Y.POS.MV>,@SM)

* Txn before and after
            MATBUILD REC FROM R.NEW
            ACTUAL.REC = REC
            MATBUILD RECOLD FROM R.OLD

            FOR Y.SV=1 TO Y.COUNT.SV
                Y.LOCREF.FLAG = ''; Y.FOUND.FIELD = ''
                Y.FIELD.NO = ''; Y.LOC.POS = ''
                Y.FIELD.LOC.NO = ''; Y.MV.NO = ''
                R.ACCOUNT = ''; R.ACCOUNT.OLD = ''

                Y.RAD.ID = R.RECORD.PARAM<REDO.MON.PARAM.VER.MAP.REF,Y.POS.MV,Y.SV>

                IF Y.RAD.ID NE '' THEN
                    Y.ACCOUNT.FIELD = R.RECORD.PARAM<REDO.MON.PARAM.VER.ACCOUNT.FIELD,Y.POS.MV,Y.SV>
                    Y.RAD.ID.PRE = R.RECORD.PARAM<REDO.MON.PARAM.VER.MAP.REF.PRE,Y.POS.MV,Y.SV>

* Account before and after
                    IF Y.ACCOUNT.FIELD NE '' THEN
* Getting position of account field
                        Y.FIELD.NO = Y.ACCOUNT.FIELD
                        CALL EB.FIND.FIELD.NO(Y.APPLICATION,Y.FIELD.NO)
                        IF Y.FIELD.NO EQ '' THEN
                            CALL GET.LOC.REF(Y.APPLICATION,Y.ACCOUNT.FIELD, Y.LOC.POS)

                            IF Y.LOC.POS EQ '' THEN
                                ERR.MSG = 'INVALID ACCOUNT FIELD ' : Y.ACCOUNT.FIELD : ' IN MONITOR PARAMETER TABLE'
                                ERR.TYPE = 'WARNING'
                                GOSUB LOG.ERROR
                            END ELSE
                                Y.FIELD.LOC.NO = 'LOCAL.REF'
                                CALL EB.FIND.FIELD.NO(Y.APPLICATION,Y.FIELD.LOC.NO)
                                Y.FIELD.NO = Y.FIELD.LOC.NO
                                Y.LOCREF.FLAG = '1'
                                Y.FOUND.FIELD = '1'
                                Y.MV.NO = Y.LOC.POS
                            END
                        END ELSE
                            Y.FOUND.FIELD = '1'
                        END

* Getting account number
                        IF Y.FOUND.FIELD EQ '1' THEN
                            BEGIN CASE
                                CASE Y.LOCREF.FLAG EQ ''
                                    Y.ACCOUNT.ID = ACTUAL.REC<Y.FIELD.NO>
                                CASE Y.LOCREF.FLAG EQ '1'
                                    Y.ACCOUNT.ID = ACTUAL.REC<Y.FIELD.NO,Y.MV.NO>
                            END CASE

* Account record after Txn
                            CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID, R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)

* Account record before Txn
                            READ R.ACCOUNT.OLD FROM F.ACCOUNT.OLD,Y.ACCOUNT.ID ELSE       ;*Tus Start
*                                CALL F.READ(FN.ACCOUNT.OLD,Y.ACCOUNT.ID,R.ACCOUNT.OLD,F.ACCOUNT.OLD,R.ACCOUNT.OLD.ERR)
                                NULL
                            END         ;*Tus End

                        END ELSE
                            ERR.TYPE = 'WARNING'
                            ERR.MSG = 'INVALID FIELD.NAME : ' : Y.ACCOUNT.FIELD
                            GOSUB LOG.ERROR
                        END

                    END
                    GOSUB SEND.QUEUE

                END ELSE
                    ERR.TYPE = 'WARNING'
                    ERR.MSG = 'MAPPING ID IS NULL. VERSION: ' : Y.VERSION.NAME
                    GOSUB LOG.ERROR
                END

            NEXT Y.SV
        END
    END

RETURN
*-----------------------------------------------------------------------------------

SEND.QUEUE:

    P.REC.ID = ID.NEW
    P.MAP.ID = Y.RAD.ID
    P.FUNCT = V$FUNCTION
    IF P.FUNCT EQ 'A' THEN    ;* PACS00562192 -S
        Y.FIELD.NO1="RECORD.STATUS"
        CALL EB.FIND.FIELD.NO(Y.APPLICATION,Y.FIELD.NO1)
        IF REC<Y.FIELD.NO1>[1,1] EQ 'R' THEN
            P.FUNCT = 'R'
        END
    END   ;* PACS00562192 -E

    P.OPERATOR = OPERATOR
    P.COMPANY = ID.COMPANY
    P.APP = APPLICATION
    P.OBJ = APPLICATION : PGM.VERSION
    P.REC.NEW = REC
    P.REC.OLD = RECOLD
    P.ACC.NEW = R.ACCOUNT
    P.ACC.OLD = R.ACCOUNT.OLD
    O.ERR = ''


    CALL APAP.TAM.redoMonPostMapQueue(P.REC.ID, P.MAP.ID, P.FUNCT, P.OPERATOR, P.COMPANY, P.APP, P.OBJ, P.REC.OLD, P.REC.NEW, P.ACC.OLD, P.ACC.NEW, O.ERR) ;*MANUAL R22 CODE CONVERSION

    IF O.ERR THEN
        ERR.MSG = 'ERROR SENDING MAPPING QUEUE. TXN: ' : ID.NEW
        ERR.TYPE = 'ERROR'
        GOSUB LOG.ERROR
    END

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
    REC.CON = Y.RAD.ID
    EX.USER = OPERATOR
    EX.PC = IP.ADDRESS

    BEGIN CASE
        CASE ERR.TYPE EQ 'WARNING'
            MON.TP = 05
        CASE ERR.TYPE EQ 'ERROR' ;*AUTO R22 CODE CONVERSION
            MON.TP = 08
    END CASE


    CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE, INT.TYPE, BAT.NO, BAT.TOT, INFO.OR, INFO.DE, ID.PROC, MON.TP, DESC, REC.CON, EX.USER, EX.PC) ;*MANUAL R22 CODE CONVERSION

RETURN
*-----------------------------------------------------------------------------

*//////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E P R O C E S S S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////////*

INITIALISE:

    PROCESS.GOAHEAD = 1
    Y.APPLICATION = APPLICATION
    Y.FIELD.MAP.REF = ''
    IP.ADDRESS = TSS$CLIENTIP
    Y.INTERF.ID = 'MON001'
    R.REDO.MONITOR.PARAMETER = ''
    Y.ERR.PARAM = ''
    Y.VERSION.NAME = ''

RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
    FN.REDO.MONITOR.PARAMETER = 'F.REDO.MONITOR.PARAMETER'
    F.REDO.MONITOR.PARAMETER = ''
    CALL OPF(FN.REDO.MONITOR.PARAMETER,F.REDO.MONITOR.PARAMETER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.OLD = 'F.ACCOUNT'
    F.ACCOUNT.OLD = ''
    CALL OPF(FN.ACCOUNT.OLD,F.ACCOUNT.OLD)

RETURN

*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:

RETURN
*-----------------------------------------------------------------------------------

END
