* @ValidationCode : MjoxNzk0NTkzODQwOlVURi04OjE3MDU5MDQzMzYyNjE6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Jan 2024 11:48:56
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BUILD.LIST.STMT.IDS(FINAL.ARRAY)
*-------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.BUILD.TRANS.PERIOD
*-------------------------------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display From.date and Until.date
*In Parameter : N/A
*Out Parameter: O.DATA
*Linked File  : REDO.E.BUILD.TRANS.PERIOD
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*     Date            Who                              Reference               Description
*    ------          ------                            -----------             --------------
*  19-09-2011       PRABHUN             PACS00125978                MODIFICATION
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion  - VM to @VM , FM to @FM , ++ to += and Added IF E EQ "EB-UNKNOWN.VARIABLE"
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 26-12-2023         Narmadha V            Manual R22 Conversion   ID Variable changed instead of hardcoding
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
    $INSERT I_F.STMT.ENTRY
*---------------------------------------------------------------------------------------------------------

    GOSUB INITIALISE.GET.VALUES
    GOSUB CHECK.MORE.THAN.180
    GOSUB PROCESS


RETURN

*----------------------------------------
INITIALISE.GET.VALUES:
*---------------------------------------
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT  = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.AI.REDO.ARCIB.PARAMETER = 'F.AI.REDO.ARCIB.PARAMETER'
    F.AI.REDO.ARCIB.PARAMETER = ''
*  CALL OPF(FN.AI.REDO.ARCIB.PARAMETER,F.AI.REDO.ARCIB.PARAMETER)

    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY  = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)
    Y.ID = "SYSTEM" ;*Manual R22 Conversion
* CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,'SYSTEM',R.AI.REDO.ARCIB.PARAMETER,ARCIB.ERR)
    CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,Y.ID,R.AI.REDO.ARCIB.PARAMETER,ARCIB.ERR) ;*Manual R22 Conversion - ID Variable changed instead of hardcoding
    Y.MIG.PARAM.CODE = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.MIGRATION.CODE>
    CHANGE @VM TO @FM IN Y.MIG.PARAM.CODE

    LREF.APP = 'ACCOUNT':@FM:'AZ.ACCOUNT'
    LREF.FIELDS = 'L.AC.AV.BAL':@FM:'L.TYPE.INT.PAY'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    POS.L.AC.AV.BAL        = LREF.POS<1,1>
    POS.L.TYPE.INT.PAY.POS = LREF.POS<2,1>


    DAYS = ''
    Y.BOOK.DATE.LEN = ''
    Y.FROM.DATE.VAL = ''
    Y.CURRENT.DAY = ''
    ST.RG.DATE=''
    END.RG.DATE=''
    END.TO.DATE=''
    Y.ID.LIST = ''
    START.FRM.DATE=''
    FLAG.ENQ = ''
    CR.DB.FLG=''
    CR.FLG=''
    DB.FLG=''
    FINAL.ARRAY=''
    END.TO.DATE = TODAY
    ACCT.ID = System.getVariable("CURRENT.ACCT.NO")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN    ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE"
        ACCT.ID = ""
    END


    LOCATE "START.DATE" IN ENQ.SELECTION<2,1> SETTING ST.DT.POS THEN
        ST.RG.DATE = ENQ.SELECTION<4,ST.DT.POS>
    END

    LOCATE "END.DATE" IN ENQ.SELECTION<2,1> SETTING END.DT.POS THEN
        END.RG.DATE = ENQ.SELECTION<4,END.DT.POS>
    END
    LOCATE "TRANS.PERIOD" IN ENQ.SELECTION<2,1> SETTING END.DT.POS THEN
        CR.DB.FLG = ENQ.SELECTION<4,END.DT.POS>
    END


    BEGIN CASE
        CASE CR.DB.FLG EQ 'Todos'
            CR.ALL.FLG =1
        CASE CR.DB.FLG EQ 'Debitos'
            DB.FLG = 1
        CASE CR.DB.FLG EQ 'Creditos'
            CR.FLG = 1
    END CASE



RETURN
*----------------------------------------

*---------------------------------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------------------------------
*PACS00125978-S


    IF ST.RG.DATE AND END.RG.DATE AND CR.DB.FLG THEN
        D.FIELDS<1> = 'ACCOUNT'
        D.FIELDS<2> = 'BOOKING.DATE'
        D.LOGICAL.OPERANDS = 1:@FM:2
        D.RANGE.AND.VALUE<1> = ACCT.ID
        D.RANGE.AND.VALUE<2> = ST.RG.DATE:@VM:END.RG.DATE
        CALL E.STMT.ENQ.BY.CONCAT(Y.ID.LIST)
        CALL F.READ(FN.AZ.ACCOUNT,ACCT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACCOUNT.ERR)
        IF R.AZ.ACCOUNT THEN
            Y.DEP.TYPE       = R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.L.TYPE.INT.PAY.POS>
            IF Y.DEP.TYPE EQ 'Reinvested' THEN
                Y.INTEREST.LIQU.ACCT = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
                D.FIELDS<1> = 'ACCOUNT'
                D.FIELDS<2> = 'BOOKING.DATE'
                D.LOGICAL.OPERANDS = 1:@FM:2
                D.RANGE.AND.VALUE<1> = Y.INTEREST.LIQU.ACCT
                D.RANGE.AND.VALUE<2> = ST.RG.DATE:@VM:END.RG.DATE
                CALL E.STMT.ENQ.BY.CONCAT(Y.AZ.ID.LIST)
                Y.ID.LIST<-1> = Y.AZ.ID.LIST
            END
        END
        Y.TRANS.ID = FIELD(Y.ID.LIST,'*',2)
    END
    GOSUB MIG.SORT.PARA

    IF NOT(Y.TRANS.ID) THEN
        Y.ID.LIST = ''
    END

    IF ST.RG.DATE GT END.RG.DATE THEN
        Y.ID.LIST = ''
    END

    LOOP

        REMOVE STMT.ARR.ID FROM Y.ID.LIST SETTING STMT.POS
    WHILE STMT.ARR.ID:STMT.POS
        AMT.TO.CHECK = FIELD(STMT.ARR.ID,'*',6)
        IF AMT.TO.CHECK LT '0' AND DB.FLG EQ '1' THEN
            FINAL.ARRAY<-1>= STMT.ARR.ID
        END
        IF AMT.TO.CHECK GT '0' AND CR.FLG EQ '1' THEN
            FINAL.ARRAY<-1> = STMT.ARR.ID
        END
        IF NOT (CR.FLG) AND NOT(DB.FLG) AND CR.ALL.FLG EQ '1' THEN
            FINAL.ARRAY<-1>  =STMT.ARR.ID
        END

    REPEAT


RETURN
**************
MIG.SORT.PARA:
**************
    Y.MIG.TOT.CNT = DCOUNT(Y.ID.LIST,@FM)

    Y.MIG.INT = 1
    LOOP
    WHILE Y.MIG.INT LE Y.MIG.TOT.CNT
        Y.MIG.STMT.ID = FIELD(Y.ID.LIST<Y.MIG.INT>,'*',2)
        CALL F.READ(FN.STMT.ENTRY,Y.MIG.STMT.ID,R.STMT.ENTRY,F.STMT.ENTRY,SE.ERR)
        Y.MIG.TXN.CODE = R.STMT.ENTRY<AC.STE.TRANSACTION.CODE>
        LOCATE  Y.MIG.TXN.CODE IN Y.MIG.PARAM.CODE SETTING Y.MIG.POS THEN
            DEL Y.ID.LIST<Y.MIG.INT>
        END
        Y.MIG.INT += 1
    REPEAT

RETURN
**************
GET.CALL.DATE:
****************
    CALL CALENDAR.DAY(END.TO.DATE,SIGN,START.FRM.DATE)
RETURN

*PACS00125978-E
********************
CHECK.MORE.THAN.180:
*******************


    IF ST.RG.DATE AND END.RG.DATE THEN
        REGION=''
        START.DATE=ST.RG.DATE
        END.DATE=END.RG.DATE
        DAYS='C'
        CALL CDD(REGION,START.DATE,END.DATE,DAYS)
    END
    IF DAYS GT 180 THEN
        ENQ.ERROR = "EB-ENTER.MONTHS.PAERIOD"
    END

RETURN
END
