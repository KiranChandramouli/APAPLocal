* @ValidationCode : MjotNzUyMjM4NzAxOkNwMTI1MjoxNjgyMzEzOTU5ODgzOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 10:55:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TEST
SUBROUTINE CHECK.CONSOL.KEY
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 24-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - ADDED END FOR IF CONDITION
* 24-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.DATES
    $INSERT I_F.STATIC.CHANGE.TODAY

    EXECUTE "COMO ON CHECK.CONSOL.KEY_":TODAY:"_":TIME()

    OPEN "&SAVEDLISTS&" TO F.BP ELSE PRINT 'Unable to open SAVEDLIST'
    READ AC.SEL FROM F.BP,'INCORR.CONSOL.KEY.LIST' ELSE PRINT 'Savedlist not input'


    GOSUB LOAD.APP
    COUNT.AC = DCOUNT (AC.SEL, @FM)
    FOR PR.AC = 1 TO COUNT.AC
        SEL.CMD = AC.SEL <PR.AC>
        GOSUB PROCESS
    NEXT PR.AC

    WRITE DETS TO F.SAVEDLISTS,"INCORR.CONSOL.KEY.LIST"

    EXECUTE "COMO OFF CHECK.CONSOL.KEY_":TODAY:"_":TIME()
RETURN


LOAD.APP:
*********

    F.ACCOUNT = 'F.ACCOUNT'
    FN.ACCOUNT = ''
    CALL OPF(F.ACCOUNT, FN.ACCOUNT)

    FN.ACCT.ACT = 'F.ACCOUNT.ACT'
    FV.ACCT.ACT = ''
    CALL OPF(FN.ACCT.ACT,FV.ACCT.ACT)

    F.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    FN.EB.CONTRACT.BALANCES = ''
    CALL OPF(F.EB.CONTRACT.BALANCES, FN.EB.CONTRACT.BALANCES)
    MNE.ID = F.ACCOUNT[2,3]

*   F.WORK1 = 'F':MNE.ID:'.CONSOL.KEY.WORK'
*   FN.WORK1 = ''
*   OPEN F.WORK1 TO FN.WORK1 ELSE
*       EXECUTE "CREATE-FILE ":F.WORK1:" TYPE=UD"
*       OPEN F.WORK1 TO FN.WORK1 ELSE
*           CRT 'Unable to open ':F.WORK1
*           STOP
*       END
*   END

    F.STATIC.CHANGE.TODAY = ''
    FN.STATIC.CHANGE.TODAY = "F.STATIC.CHANGE.TODAY"
    CALL OPF(FN.STATIC.CHANGE.TODAY, F.STATIC.CHANGE.TODAY)

    FN.SAVEDLISTS = "&SAVEDLISTS&"
    F.SAVEDLISTS = ""
    CALL OPF(FN.SAVEDLISTS,F.SAVEDLISTS)
    DETS = ""
*  SL.CMD = 'SELECT ':F.EB.CONTRACT.BALANCES
*  SEL.LIST = ''; NO.REC = ''; RET = '';
    POS = ''
*  ACC.ID = ''
*  AC.SEL = ''
*  CALL EB.READLIST(SL.CMD, AC.SEL, '', NO.REC, RET)

RETURN

PROCESS:
********

*    CRT "Processing ":AC.SEL <PR.AC>:" ..."
    R.ECB = ''
    READ R.ECB FROM FN.EB.CONTRACT.BALANCES, SEL.CMD ELSE R.ECB = ''
    IF R.ECB<ECB.PRODUCT> NE 'AC' THEN
        RETURN
    END

    OLD.CONSOL.KEY = R.ECB<ECB.CONSOL.KEY>
    TXN.CODE = ''
    APP.ID = R.ECB<ECB.PRODUCT>
    APPL.NAME = R.ECB<ECB.APPLICATION>
    YERR = ''
    NEW.CONSOL.KEY = ''
    CONSOL.COMPANY = R.ECB<ECB.CO.CODE>
    ECB.COMPANY = R.ECB<ECB.CO.CODE>

    R.STATIC.CHANGE.TODAY = ''
    READ R.STATIC.CHANGE.TODAY FROM F.STATIC.CHANGE.TODAY, SEL.CMD ELSE R.STATIC.CHANGE.TODAY = ''
    PRODUCT = R.STATIC.CHANGE.TODAY<RE.SCT.PRODUCT, 1>
    TXN.CODE = R.STATIC.CHANGE.TODAY<RE.SCT.CRF.TXN.CODE, 1>

    IF APPL.NAME EQ 'ACCOUNT' THEN
        R.ACC = ''
        READ R.ACC FROM FN.ACCOUNT, SEL.CMD ELSE
            R.ACC = ''
            RETURN
        END
***
        IF R.ACC<AC.CURR.NO> EQ '1' THEN
            RETURN
        END ;*R22 AUTO CONVERSTION ADDED END
***
******        CRT "Processing ":AC.SEL <PR.AC>:" ..."
        CONSOL.COMPANY = R.ACC<AC.CO.CODE>
        AC.COMPANY = R.ACC<AC.CO.CODE>

    END

    IF (R.ACC<AC.CATEGORY> EQ "3200")  OR   (R.ACC<AC.CATEGORY> EQ "3152") OR (R.ACC<AC.CATEGORY> EQ "6001") OR (R.ACC<AC.CATEGORY> EQ "6501") THEN

        SAVE.COMPANY = ID.COMPANY
        IF CONSOL.COMPANY NE ID.COMPANY THEN
            ID.COMPANY = CONSOL.COMPANY
        END

        GOSUB GET.CONSOL.KEY
        IF R.ACC<AC.ARRANGEMENT.ID> THEN
            YCONSOL.APP.IDS<2> = R.ACC<AC.ARRANGEMENT.ID>
        END ;*R22 AUTO CONVERSTION ADDED END

        CALL EB.ALLOCATE.AL.KEY(CONSOL.APP.ID, YCONSOL.APPS, YCONSOL.APP.IDS, '', NEW.CONSOL.KEY, YERR)

        ID.COMPANY = SAVE.COMPANY

        IF NEW.CONSOL.KEY NE OLD.CONSOL.KEY THEN

*************
            ACCOUNT.ACT.ID = ""
            ACT.CUR.NO = ""
            R.ACCOUNT.ACT = ""
            ACT.CUR.NO = R.ACC<AC.CURR.NO>-1
            ACCOUNT.ACT.ID = SEL.CMD:";":ACT.CUR.NO
            READ R.ACCOUNT.ACT FROM FV.ACCT.ACT,ACCOUNT.ACT.ID THEN
                RETURN
            END
*************
            CRT APP.ID:' Contract ':SEL.CMD:' with incorrect consol key = ':OLD.CONSOL.KEY:' correct value = ':NEW.CONSOL.KEY
            DETS<-1>=SEL.CMD
*DETS<-1>=SEL.CMD:'#':OLD.CONSOL.KEY:'#':NEW.CONSOL.KEY


*      DETS = SEL.CMD:'#':OLD.CONSOL.KEY:'#':NEW.CONSOL.KEY:'#':AC.COMPANY:'#':ECB.COMPANY
*       DET.ID = APP.ID:'#':SEL.CMD
*       WRITE DETS TO FN.WORK1, DET.ID
*****Update ACCOUNT.ACCT file***************
*       R.ACCT.ACT = TODAY
*       WRITE R.ACCT.ACT TO FV.ACCT.ACT, SEL.CMD

********************************************

*       IF APP.ID EQ 'AC' THEN
*R.ECB<ECB.CONSOL.KEY>=NEW.CONSOL.KEY
*           R.ECB<ECB.CO.CODE>=AC.COMPANY
*           WRITE R.ECB TO FN.EB.CONTRACT.BALANCES, SEL.CMD
*       END
        END

    END




RETURN

*==============
GET.CONSOL.KEY:
*==============

    CONSOL.APP.ABBREV = 'COND.APP'
    CONSOL.APP.FILES = ''
    CALL RE.APPLICATIONS(CONSOL.APP.ABBREV,CONSOL.APP.FILES)

    LOCATE APP.ID IN CONSOL.APP.ABBREV SETTING POS THEN
        YCONSOL.APPS = RAISE(CONSOL.APP.FILES<2,POS>)
    END
    YCONSOL.APP.IDS = SEL.CMD

    CONSOL.APP.ID = APP.ID

RETURN


END
