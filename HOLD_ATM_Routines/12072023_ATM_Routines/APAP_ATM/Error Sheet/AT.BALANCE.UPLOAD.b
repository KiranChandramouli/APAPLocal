SUBROUTINE AT.BALANCE.UPLOAD
*
*Subroutine to build and send balances to the switch for for use in offline txns
*
*************************************************************************
* CHANGE HISTORY:
****************
* 24-10-2007 -  Changes done by Muthamizh M
*               Changes done for the issue (HD0719013)
*               The format of the flat file is changed for the requirement
************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_F.ATM.PARAMETER
    $INSERT I_F.MNEMONIC.COMPANY
    $INSERT I_F.ACCT.GROUP.CONDITION
    $INSERT I_F.COMPANY
    $INSERT I_F.CURRENCY
    $INSERT I_F.SPF
    $INSERT I_F.POSTING.RESTRICT
    $INSERT I_F.LIMIT
    $INSERT I_F.DEPT.ACCT.OFFICER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.EB.CONTRACT.BALANCES        ;*/ TUS START/END

*

    GOSUB INITIALISE
*

    LOOP
        REMOVE MNE.COMP FROM MNE.LIST SETTING MNE.POSN
    WHILE MNE.COMP
        CALL CACHE.READ(FN.MNEMONIC.COMPANY, MNE.COMP, R.MNEMONIC.COMPANY, ER.MNEMONIC.COMPANY)
        IF R.MNEMONIC.COMPANY<AC.MCO.COMPANY> THEN
            PRINT 'Processing branch---> ':MNE.COMP
            COMP.ID=R.MNEMONIC.COMPANY<AC.MCO.COMPANY>

            CALL CACHE.READ(FN.COMPANY, COMP.ID, COMP.REC, COMP.ERR)
            IF COMP.REC<EB.COM.CONSOLIDATION.MARK> EQ 'N' THEN
                CALL LOAD.COMPANY(R.MNEMONIC.COMPANY<AC.MCO.COMPANY>)
                GOSUB OPEN.FILES

            END
        END
    REPEAT
    GOSUB WRITE.TO.FILE



RETURN


OPEN.FILES:
*-----------*
*
    FN.ACCOUNT = 'F.ACCOUNT'
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*

    FN.POSTING.RESTRICT = 'F.POSTING.RESTRICT'
    CALL OPF(FN.POSTING.RESTRICT,F.POSTING.RESTRICT)

    FN.DEPT.ACCT.OFFICER = "F.DEPT.ACCT.OFFICER"
    F.DEPT.ACCT.OFFICER = ""
    CALL OPF(FN.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER)
*

    SEL.ACCT = 'SELECT ':FN.ACCOUNT
    SEL.ACCT := ' WITH ATM.FLAG EQ ':'Y'
    CALL EB.READLIST(SEL.ACCT,ACCT.LIST,'',NO.SELECTED,ER.SEL.ACCT)
    LOOP
        REMOVE Y.ACCT.NO FROM ACCT.LIST SETTING AC.POSN
    WHILE Y.ACCT.NO DO
        CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCT,F.ACCOUNT,ER.ACCT)
        CALL EB.READ.HVT('EB.CONTRACT.BALANCES',Y.ACCT.NO,R.ECB,ECB.ERR)        ;*/ TUS START.END
        IF R.ACCT THEN

            ACCT.NAME = R.ACCT<AC.SHORT.TITLE>

            FN.ACCT.GRP.CON= 'F.ACCT.GROUP.CONDITION'
            CALL OPF(FN.ACCT.GRP.CON,F.ACCT.GRP.CON)

*            FN.LIM = 'F.LIMIT' ; F.LIM = ''
*            CALL OPF(FN.LIM,F.LIM)

*added anitha S

            GROUP.NO=R.ACCT<AC.CONDITION.GROUP>
            AC.CYY=R.ACCT<AC.CURRENCY>
*Added by Muthamizh - s (HD0719013)
            CALL CACHE.READ(FN.CURRENCY, AC.CYY, R.CCY, CCY.ERR)
            IF R.CCY THEN
                CCY.CODE = R.CCY<EB.CUR.NUMERIC.CCY.CODE>
                CCY.CODE = FMT(CCY.CODE,'R%3')
            END
* Commented by Muthamizh - s (HD0719013)
*            ACCT.OFF = R.ACCT<AC.ACCOUNT.OFFICER>

*            CALL F.READ(FN.DEPT.ACCT.OFFICER,ACCT.OFF,R.DAO,F.DEPT.ACCT.OFFICER,DAO.ERR)
*            IF R.DAO THEN
*                BRANCH.ID = R.DAO<EB.DAO.NAME>
*            END
* Commented by Muthamizh - E (HD0719013)

*Added by Muthamizh - E (HD0719013)

            Y.AC.GRP.ID=GROUP.NO:AC.CYY
            CALL CACHE.READ(FN.ACCT.GRP.CON, Y.AC.GRP.ID, R.AC.GRP.COND, ER.ACC.CON)

            IF R.AC.GRP.COND THEN
                MINIMUM.AC.AMT = R.AC.GRP.COND<ACCT.GRP.MINIMUM.BAL>
            END ELSE
                MINIMUM.AC.AMT = 0
            END

            AC.CUS = R.ACCT<AC.CUSTOMER>
            CALL F.READ(FN.CUSTOMER,AC.CUS,R.CUSTOMER,F.CUSTOMER,CUST.ERR)
            IF R.CUSTOMER THEN
                REGION = R.CUSTOMER<EB.CUS.NATIONALITY>
            END
*Added by Muthamizh - s (HD0719013)
*            AC.LIMIT = R.ACCT<AC.LIMIT.REF>
*            LIM.REF = FMT(AC.LIMIT,"10'0'R")

*            IF AC.LIMIT THEN
*                CALL DBR("CUSTOMER":FM:EB.CUS.CUSTOMER.LIABILITY,AC.CUS,LIAB.CUS)
*                IF LIAB.CUS THEN
*                    LIM.ID = LIAB.CUS:'.':LIM.REF:'.':AC.CUS
*                END ELSE
*                    LIM.ID = AC.CUS:'.':LIM.REF
*                END
*                LIM.REC = ''
*                LIMERR = ''
*                CALL F.READ(FN.LIM,LIM.ID,LIM.REC,F.LIM,LIMERR)
*                AV.LIMIT.AMT = LIM.REC<LI.AVAIL.AMT,1>
*            END ELSE
*                AV.LIMIT.AMT = 0
*            END
*added anitha E

*Added by Muthamizh - E (HD0719013)


            GOSUB BUILD.ACCT.BAL.DETAILS
        END

    REPEAT



RETURN          ;*From open files

*----------------------------------------------------------------------*

BUILD.ACCT.BAL.DETAILS:
*-----------------*

*    DETAIL.RECORD<-1>='U':','
*    DETAIL.RECORD:= FMT(Y.ACCT.NO,'R%14'):','
*Added by Muthamizh - s (HD0719013)
    BRANCH.ID = Y.ACCT.NO[1,3]
    IF LEN(ACCT.NAME) GT 32 THEN
        ACCT.NAME = ACCT.NAME[1,32]
    END
    DETAIL.RECORD<-1> = BIN.NO:'[0x1c]'
    DETAIL.RECORD:= Y.ACCT.NO:'[0x1c]'
    DETAIL.RECORD:= ACCT.NAME:'[0x1c]'
    DETAIL.RECORD:= REGION:'[0x1c]'
    DETAIL.RECORD:= BRANCH.ID:'[0x1c]'
    DETAIL.RECORD:= ACC.STATUS:'[0x1c]'
    DETAIL.RECORD:= CCY.CODE:'[0x1c]'

*Added by Muthamizh - E (HD0719013)

    DET.ADD.CNT+=1;
*    WORK.BAL = R.ACCT<AC.WORKING.BALANCE>        ;*/ TUS START
    WORK.BAL = R.ECB<ECB.WORKING.BALANCE>

*added anitha s/e;
*    LEDGER.BAL=R.ACCT<AC.ONLINE.ACTUAL.BAL>
    LEDGER.BAL=R.ECB<ECB.ONLINE.ACTUAL.BAL>        ;*/ TUS END

* Commented and Changed by Muthamizh - S (HD0719013)
*    GOSUB CALC.AVAIL.BAL
    AVAIL.BAL = WORK.BAL
* Commented and Changed by Muthamizh - E (HD0719013)

    LEDGER.BAL1=FMT(FIELD(ABS(LEDGER.BAL),'.',1),'R%10')
    LEDGER.BAL2=FMT(FIELD(ABS(LEDGER.BAL),'.',2),'R%2')

    AVAIL.BAL1 = FMT(FIELD(ABS(AVAIL.BAL),'.',1),'R%10')
    AVAIL.BAL2 = FMT (FIELD(ABS(AVAIL.BAL),'.',2),'R%2')

*    IF LEDGER.BAL LT '0' THEN
*        DETAIL.RECORD:='-'
*    END
*
*Added by Muthamizh - s (HD0719013)
    IF AVAIL.BAL LT '0' AND AVAIL.BAL NE "" THEN
        DETAIL.RECORD:='-'
    END
    DETAIL.RECORD:=AVAIL.BAL1:AVAIL.BAL2:'[0x1c]'
*Added by Muthamizh - E (HD0719013)

    IF LEDGER.BAL LT '0' AND LEDGER.BAL NE "" THEN
        DETAIL.RECORD:='-'
    END

    LEDGER.BAL=LEDGER.BAL1:LEDGER.BAL2
    DETAIL.RECORD:=LEDGER.BAL

*    IF AVAIL.BAL LT '0' THEN
*        DETAIL.RECORD:='-'
*    END

* COMMENTED by Muthamizh - s (HD0719013)
*    DETAIL.RECORD:=AVAIL.BAL1:AVAIL.BAL2:','      ;*wrkbal- lockamt

*    CALL F.READ(FN.ACCOUNT.CLASS,'SAVINGS',R.ACCT.CLASS,F.ACCOUNT.CLASS,ERR)
*    SAV.ACCT.CATEG = R.ACCT.CLASS<AC.CLS.CATEGORY>
*    ACCATEG = R.ACCT<AC.CATEGORY>
*    FIND ACCATEG IN SAV.ACCT.CATEG SETTING SAV.FOUND.POSN1,SAV.FOUND.POSN ELSE SAV.FOUND.POSN = ''
*    IF SAV.FOUND.POSN THEN
*     IF R.ACCT<AC.CATEGORY> EQ SAV.ACCT.CATEG THEN
*        ACC.TYPE ='10'
*    END ELSE
*        ACC.TYPE ='20'

*    END
*    DETAIL.RECORD:=ACC.TYPE
* COMMENTED by Muthamizh - s (HD0719013)

RETURN          ;*Build file details

*-----------------------------------------------------------------------*

INITIALISE:
*----------*
*
    REGION = ""
    ACC.TYPE = ""
    ACC.STATUS = ""
    BITMAP = ""
    DETAIL.OUT = ""
    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ATM.PARAMETER = 'F.ATM.PARAMETER'
    CALL OPF(FN.ATM.PARAMETER,F.ATM.PARAMETER)
*
    FN.COMPANY='F.COMPANY'
    CALL OPF(FN.COMPANY,F.COMPANY)

    FN.MNEMONIC.COMPANY = 'F.MNEMONIC.COMPANY'
    CALL OPF(FN.MNEMONIC.COMPANY,F.MNEMONIC.COMPANY)
*
    FN.ACCOUNT.CLASS = 'F.ACCOUNT.CLASS'
    CALL OPF(FN.ACCOUNT.CLASS,F.ACCOUNT.CLASS)
*
    FN.CURRENCY = 'F.CURRENCY'
    CALL OPF(FN.CURRENCY,F.CURRENCY)
*

    FN.ACCOUNT.CLASS = 'F.ACCOUNT.CLASS'
    CALL OPF(FN.ACCOUNT.CLASS,F.ACCOUNT.CLASS)

    DETAIL.RECORD=''
    OPERATING.SYSTEM = R.SPF.SYSTEM<SPF.OPERATING.SYSTEM>
    FTP.SCRIPT = 'ftpput.sh'
    REMOTE.IP = '192.168.6.105'
    REMOTE.DIR = 'hblrnf'     ;*FTP parameters
    LC.DIR = 'UPLOAD'
    FTP.USER = 'oasisadm'
    FTP.PASSWD ='oasisadm'
    SPC =' '
    DET.ADD.CNT = 0
    DET.DEL.CNT = 0

    CALL F.READ(FN.ACCOUNT.CLASS,'SAVINGS',R.ACCT.CLASS,F.ACCOUNT.CLASS,ER.ACCT.CLASS)


*    CALL F.READ(FN.ATM.PARAMETER,'SYSTEM',R.ATM.PARAMETER,F.ATM.PARAMETER,ER.ATM.PARAMETER)        ;*/ TUS START/END
    CALL CACHE.READ(FN.ATM.PARAMETER,'SYSTEM',R.ATM.PARAMETER,ER.ATM.PARAMETER)
    BIN.NO=R.ATM.PARAMETER<ATM.PARA.BANK.IMD>
    IF BIN.NO EQ "" THEN
        BIN.NO = 1
    END
    U.ATM.BAL.UPLOAD.PATH =R.ATM.PARAMETER<ATM.PARA.BAL.UPLOAD.PATH>
* Added by Muthamizh - S (HD0720005)
    U.ATM.BAL.UPLOAD.FILE = R.ATM.PARAMETER<ATM.PARA.BAL.UPLOAD.FILE>:".":TODAY
* Added by Muthamizh - E (HD0720005)
    FTP.FILE.NAME =U.ATM.BAL.UPLOAD.FILE

    IF ER.ATM.PARAMETER THEN

        PRINT 'Error!Could not read ATM.PARAMETER'
    END

    SEL.MNE.COMP = 'SELECT ':FN.MNEMONIC.COMPANY
    CALL EB.READLIST(SEL.MNE.COMP,MNE.LIST,'',NO.OF.REC,U.ERR)


RETURN

*------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
CALC.AVAIL.BAL:
*--------------*

    IF R.ACCT<AC.FROM.DATE> THEN
        U.LOCK.AMT =0
        U.CTR = DCOUNT(R.ACCT<AC.FROM.DATE>,@VM)
        FOR U.I = 1 TO U.CTR

            IF TODAY GE R.ACCT<AC.FROM.DATE,U.I> THEN

                U.LOCK.AMT += R.ACCT<AC.LOCKED.AMOUNT,U.I>
            END
        NEXT U.I
*        AVAIL.BAL = WORK.BAL - U.LOCK.AMT

*added anitha s
        IF U.LOCK.AMT GT MINIMUM.AC.AMT THEN
            AVAIL.BAL = WORK.BAL - U.LOCK.AMT
        END ELSE
            AVAIL.BAL = WORK.BAL - MINIMUM.AC.AMT
        END
    END ELSE
        AVAIL.BAL = WORK.BAL - MINIMUM.AC.AMT
    END   ;*added anitha e



RETURN          ;*From calc.avail.bal

*------------------------------------------------------------------------*
WRITE.TO.FILE:
*-------------*

    U.ATM.BAL.UPLOAD.PATH.NAME = U.ATM.BAL.UPLOAD.PATH:'/':U.ATM.BAL.UPLOAD.FILE
*added by anitha s
*added to delete the file and to do a fresh write instead of overwriting
    OPEN U.ATM.BAL.UPLOAD.PATH TO EMPTY.OUT  ELSE CRT "OPEN ERROR"
    REC=''
    READ REC FROM EMPTY.OUT,U.ATM.BAL.UPLOAD.FILE ELSE CRT "READ ERROR"
    IF REC THEN
        DELETE EMPTY.OUT,U.ATM.BAL.UPLOAD.FILE ON ERROR CRT "DEL ERROR"
    END
* added by anitha e
    OPENSEQ U.ATM.BAL.UPLOAD.PATH.NAME TO F.OUT ELSE
*    OPENSEQ 'UPLOAD',U.ATM.BAL.UPLOAD.FILE TO F.OUT ELSE
        CREATE F.OUT ELSE CALL TRANSACTION.ABORT
        WEOFSEQ F.OUT
    END
    LIN.FEED = CHARX(10)
*   CONVERT FM TO LIN.FEED IN DETAIL.RECORD
    LOOP
        REMOVE REC.LIST FROM DETAIL.RECORD SETTING REC.POS
    WHILE REC.LIST
        FS.CNT = DCOUNT(REC.LIST,"[0x1c]")
        BITMAP = ""
        DETAIL.OUT = ""
        FOR FS.CTR = 1 TO FS.CNT
            TEST = FIELD(REC.LIST,"[0x1c]",FS.CTR)
            IF FIELD(REC.LIST,"[0x1c]",FS.CTR) OR FIELD(REC.LIST,"[0x1c]",FS.CTR) EQ 0 THEN
                BITMAP:= 1
                DETAIL.OUT := FIELD(REC.LIST,"[0x1c]",FS.CTR):CHARX(28)
            END ELSE
                BITMAP:= 0
            END
        NEXT FS.CTR
        BITMAP:= 00000000000000000000000
        INFO<-1> = "ACT":2:BITMAP:DETAIL.OUT
    REPEAT
    CHANGE @FM TO LIN.FEED IN INFO

    WRITESEQ INFO TO F.OUT ELSE PRINT 'Failed to write'

* Added by Muthamizh - S (HD0720005)
    REC = ""
    U.ATM.BAL.UPLOAD.PATH.NAME = U.ATM.BAL.UPLOAD.PATH
    FILE.NAME = U.ATM.BAL.UPLOAD.FILE:".ready"
    OPEN U.ATM.BAL.UPLOAD.PATH TO F.OUT  ELSE CRT "OPEN ERROR"
    WRITE REC TO F.OUT,FILE.NAME
* Added by Muthamizh - E (HD0720005)
*    IF OPERATING.SYSTEM EQ "UNIX" THEN
*        PRINT "Transferring file..."
*        CMD = "SH -c '":FTP.SCRIPT:SPC:REMOTE.IP:SPC:LC.DIR:SPC:FTP.FILE.NAME
*        CMD := SPC:REMOTE.DIR:SPC:FTP.USER:SPC:FTP.PASSWD:SPC:"'"

*        EXECUTE CMD SETTING RETURN.STATUS CAPTURING CAPTURE.MSG
*    END
RETURN          ;*From write to file

END
