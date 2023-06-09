* @ValidationCode : MjozMjA1NTg2MjE6Q3AxMjUyOjE2ODUwMTQxNTc1NDY6SGFyaXNodmlrcmFtQzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 May 2023 16:59:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*25/05/2023      CONVERSION TOOL         AUTO R22 CODE CONVERSION           FM TO @FM, SM TO @SM,++ TO +=
*25/05/2023      HARISH VIKRAM              MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.B.ADDGEST.CHARGE(ARR.ID)
*-----------------------------------------------------------------------------


    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_REDO.B.ADDGEST.CHARGE.COMMON
****GETTING ARRANGEMENT ID*****
    IF ARR.ID NE '' THEN
        R.APP.RECORD<AA.ARR.ACT.ARRANGEMENT> = ARR.ID
        R.APP.RECORD<AA.ARR.ACT.ACTIVITY> = "LENDING-CHANGE.PRODUCT-ARRANGEMENT"
        R.APP.RECORD<AA.ARR.ACT.EFFECTIVE.DATE> = ''
        R.APP.RECORD<AA.ARR.ACT.PROPERTY,1> = 'REPAYMENT.SCHEDULE'
        R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,-1> = 'PROPERTY:1:3'
        R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,-1> = 'GESTIONCOBROS'
        R.APP.RECORD<AA.ARR.ACT.PROPERTY,2> = 'APAP.OVERDUE'
        GOSUB GET.OVERDUE.COND

        APP.NAME = 'AA.ARRANGEMENT.ACTIVITY'
        OFS.FUNCTION='I'
        PROCESS='PROCESS'
        OFSVERSION='AA.ARRANGEMENT.ACTIVITY,REDO.ADDGEST'
        GTSMODE=''
        NO.OF.AUTH='0'
        TRANSACTION.ID= ''

        OFS.STRING=''

        CALL OFS.BUILD.RECORD(APP.NAME,OFS.FUNCTION,PROCESS,OFSVERSION,GTS.MODE,NO.OF.AUTH,TRANSACTION.ID,R.APP.RECORD,OFS.MESSAGE)

        OFS.DATA = OFS.MESSAGE
        OFS.ID = 'AA.COB'
        CALL OFS.CALL.BULK.MANAGER(OFS.ID,OFS.DATA,RESP,COMM)
****SUCESS OR FAIL MSG EXTRACT****
        IF INDEX(RESP,'//-1/',1) THEN
            Y.RESP.ARRAY1 = FIELD(RESP,'//-1/',2)
            Y.OUT.MSG = FIELD(Y.RESP.ARRAY1,'</request><request>',1)
        END ELSE
            IF (NOT(Y.OUT.MSG) OR Y.OUT.MSG EQ 'SUCCESS') AND ARR.ID THEN
                Y.OUT.MSG = 'SUCCESS'
            END
        END
****WRITING***
        DELIM = '|'
        FINAL.ARRAY = ''
        FINAL.ARRAY<-1> = ARR.ID:DELIM:Y.OUT.MSG
        WRITE FINAL.ARRAY TO F.TEMP.FILE.PATH,ARR.ID
    END

RETURN

GET.OVERDUE.COND:
*****************
    returnError = '' ; returnIds = ''; effectiveDate = '' ; idPropertyClass = 'OVERDUE' ; idProperty = '' ; returnConditions = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ARR.ID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.ARR.OVERDUE = RAISE(returnConditions)
    OVERDUE.STATUS.LIST = R.ARR.OVERDUE<AA.OD.OVERDUE.STATUS>
    AGEING.TYPE.LIST = R.ARR.OVERDUE<AA.OD.AGEING.TYPE>
    AGEING.LIST = R.ARR.OVERDUE<AA.OD.AGEING>
    AGE.ALL.BILLS.LIST = R.ARR.OVERDUE<AA.OD.AGE.ALL.BILLS>
    MOVE.BALANCE.LIST = R.ARR.OVERDUE<AA.OD.MOVE.BALANCE>
    EFFECTIVE.DATE.LIST = R.ARR.OVERDUE<AA.OD.EFFECTIVE.DATE>

    CHANGE @SM TO @FM IN OVERDUE.STATUS.LIST
    CHANGE @SM TO @FM IN AGEING.TYPE.LIST
    CHANGE @SM TO @FM IN AGEING.LIST
    CHANGE @SM TO @FM IN AGE.ALL.BILLS.LIST
    CHANGE @SM TO @FM IN MOVE.BALANCE.LIST
    CHANGE @SM TO @FM IN EFFECTIVE.DATE.LIST
    NEW.AGEING = '6'

    CNT = 1
    TOT.CNT = DCOUNT(OVERDUE.STATUS.LIST, @FM)
    LOOP
    WHILE CNT LE TOT.CNT
        LOCATE 'DU2' IN OVERDUE.STATUS.LIST<1> SETTING AGE.POS THEN
        END ELSE
            IF NEW.AGEING LT AGEING.LIST<CNT> THEN
                INS 'DU2' BEFORE OVERDUE.STATUS.LIST<CNT>
                INS 'DAYS' BEFORE AGEING.TYPE.LIST<CNT>
                INS '7' BEFORE AGEING.LIST<CNT>
                INS 'NO' BEFORE AGE.ALL.BILLS.LIST<CNT>
                INS 'YES' BEFORE MOVE.BALANCE.LIST<CNT>
                INS 'DUE' BEFORE EFFECTIVE.DATE.LIST<CNT>
            END
        END
        GOSUB UPDATE.OVERDUE.FIELDS
        CNT += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT

RETURN

UPDATE.OVERDUE.FIELDS:
**********************
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,2,-1> = 'OVERDUE.STATUS:1:':CNT:''
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,2,-1> = OVERDUE.STATUS.LIST<CNT>
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,2,-1> = 'AGEING.TYPE:1:':CNT:''
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,2,-1> = AGEING.TYPE.LIST<CNT>
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,2,-1> = 'AGEING:1:':CNT:''
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,2,-1> = AGEING.LIST<CNT>
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,2,-1> = 'AGE.ALL.BILLS:1:':CNT:''
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,2,-1> = AGE.ALL.BILLS.LIST<CNT>
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,2,-1> = 'MOVE.BALANCE:1:':CNT:''
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,2,-1> = MOVE.BALANCE.LIST<CNT>
    R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,2,-1> = 'EFFECTIVE.DATE:1:':CNT:''
    R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,2,-1> = EFFECTIVE.DATE.LIST<CNT>

RETURN
END