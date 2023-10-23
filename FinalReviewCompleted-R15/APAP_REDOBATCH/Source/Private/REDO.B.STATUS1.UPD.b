* @ValidationCode : Mjo0Nzg0OTY4Nzc6Q3AxMjUyOjE2OTc3OTE0NTM0NjU6SVRTUzotMTotMTo1NTM6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Oct 2023 14:14:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 553
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
*-----------------------------------------------------------------------------
* <Rating>-136</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.STATUS1.UPD(ID)
*------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RAJA SAKTHIVEL K P
* PROGRAM NAME : REDO.B.STATUS1.UPD
*------------------------------------------------------------------
* Description : This is the update rotuine which will find out the status
* of the customer accounts based on a particular time period
*------------------------------------------------------------------
* MODIFICATION HISTORY
*-------------------------------
*-----------------------------------------------------------------------------------
*    NAME                 DATE                ODR              DESCRIPTION
* RAJA SAKTHIVEL K P   2009-12-15       ODR-2009-10-0339     INITIAL VERSION
* KAVITHA              2010-10-24       ODR-2009-10-0339     Parameter for EB.NO.OF.MONTHS modified
* H Ganesh.            20-Apr-2011          PACS00054881     Changed the logic to set the L.AC.STATUS1 as per months defined in EB.LOOKUP
* JEEVA T              05-07-2011       PACS00084781         Selecting only saving,current,sweep account
* Prabhu N              03-10-2011       PACS00136023         AC.WAIVE.LEDGER.FEE-updation added
* JEEVA T               01-12-2011        COB PREFORMANCE     REDO.UPD.ACC.LIST - write has been modified
* prabhu                10-01-2012       PACS00172828         call routine parameter updated
* Shek                  17-04-2012       Performance          Read az/az$his if account relates to deposit
* Riyas                 20-05-2012      Change Request 12     changed the Logic to set the L.AC.STATUS1 as per MONTHS or DAYS parameterized in EB.LOOKUP
* Shek                  04-02-2013      performance
*                                                             REDO.CUST.PRD.LST is updated with session number as part of ID
*                                                             REDO.B.STATUS1.UPD.POST job will merge all the data from
*                                                             REDO.CUST.PRD.LST to REDO.CUST.PRD.LIST
* Aslam                 07-08-2015       PACS00472936     Fix for the issues
* DATE              NAME                     REFERENCE             DESCRIPTION
* 31 JAN 2023     Edwin Charles D         ACCOUNTING-CR           TSR479892
* 20 AUG 2023     Edwin Charles D         ACCOUNTING-CR           TSR637100
* 19 OCT 2023     VICTORIA S             MANUAL CONVERSION          FM TO @FM,VM TO @VM, SM TO @SM,CALL ROUTINE MODIFIED
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.DATES
    $INSERT I_F.ACCOUNT.PARAMETER
    $INSERT I_REDO.B.STATUS1.UPD.COMMON
    $INSERT I_F.REDO.CUST.PRD.LIST
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.REDO.UPD.ACC.LIST
    $INSERT JBC.h
    $INSERT I_F.EB.CONTRACT.BALANCES    ;*Tus S/E
    $USING APAP.REDOAPAP
    LAST.CR.DT =''
    LAST.DR.DT = ''
    Y.STATUS.1 = ''
    Y.STATUS.2 = ''
    Y.CONT.FLAG.ST = ''
    Y.CONT.FLAG.END = ''
    Y.CONT.FLAG = ''
    Y.CNT = ''
    Y.COUNT = ''
    Y.DEPOSIT.ACCOUNT = ''
    Y.FUTURE.DATE = ''
    Y.ALL.FUTURE.DATE = ''
    Y.PREV.SELECT.STATUS = ''
    SYS.DATE = ''
    Y.CAT.ACCOUNT = ''
    Y.STATUS.UPD=''
    Y.WAIVE.CHG.UPD=''
    R.AZ.ACCOUNT=''
    Y.STATUS.CHG.UPD=''
    Y.AC.ST.POS=''
    GOSUB ACCOUNT.CHECK

    GOSUB CHECK.MONTHS

RETURN
*-----------------------------------------------------------
ACCOUNT.CHECK:
*-----------------------------------------------------------
*Description : Selection Saving, Current,Sweep Account
*-----------------------------------------------------------

    CALL F.READ(FN.ACCOUNT,ID,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
*TUS START
*  CALL EB.READ.HVT ("EB.CONTRACT.BALANCES",ID, R.ECB, ECB.ERR)
*TUS END

    Y.CAT.ACCOUNT = R.ACCOUNT<AC.CATEGORY>
    Y.DEPOSIT.ACCOUNT = R.ACCOUNT<AC.ALL.IN.ONE.PRODUCT>
*    IF NOT(Y.DEPOSIT.ACCOUNT) THEN
*        Y.CONT.FLAG = '1'
*    END
RETURN
CHECK.MONTHS:
*-----------------------------------------------------------
* Description : Current date and last accessed date values are compared
* and no.of.months value is obtained and compared with required values
*-----------------------------------------------------------
*TUS START

    LAST.CR.DT = R.ACCOUNT<AC.DATE.LAST.CR.CUST>
    LAST.DR.DT = R.ACCOUNT<AC.DATE.LAST.DR.CUST>

*    LOCATE 'CUST-CR' IN R.ECB<ECB.INITIATOR.TYPE,1> SETTING CUST.CR.POS THEN
*    LAST.CR.DT = R.ECB<ECB.DATE.LAST,CUST.CR.POS>
*    END
*    LOCATE 'CUST-DR' IN R.ECB<ECB.INITIATOR.TYPE,1> SETTING CUST.DR.POS THEN
*    LAST.DR.DT = R.ECB<ECB.DATE.LAST,CUST.DR.POS>
*    END
*TUS END
*    SYS.DATE = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    SYS.DATE = TODAY


    IF LAST.DR.DT EQ '' OR LAST.CR.DT EQ '' THEN
        GOSUB ZERO.CHECK
    END ELSE
        GOSUB FULL.CHECK
    END

    IF NOT(Y.LAST.TRANSACTION.DATE) THEN
        Y.LAST.TRANSACTION.DATE = R.ACCOUNT<AC.OPENING.DATE>
    END

*-------------------------------------------------
* No.of.Months value is compared here
*-------------------------------------------------
*Shek -start

    jPos = ""
    MatchDate = ""
*Locate the date in sorted array
    LOCATE Y.LAST.TRANSACTION.DATE IN SORTED.DATES<1> BY "AN" SETTING jPos ELSE
    END
    MatchDate = SORTED.DATES<jPos>

*Locate the date in LOOKUP.ARRAY
    POS2 = 0
    LOCATE MatchDate IN Y.LOOKUP.ARRAY<4,1> SETTING POS2 THEN
        Y.PREV.SELECT.STATUS = Y.LOOKUP.ARRAY<1,POS2>
        Y.PREV.WAIVE.LEDGER  = Y.LOOKUP.ARRAY<3,POS2>
    END

    GOSUB OD.CATEG.CHECK
    Y.AZ.DEP.LIQ.ACCT = R.ACCOUNT<AC.LOCAL.REF,Y.AZ.ACC.REF.POS>
    IF NOT(R.AZ.ACCOUNT) AND NOT(Y.AZ.DEP.LIQ.ACCT) THEN
        GOSUB CHANGE.STATUS
    END

*-    END

*Shek -e

*-------------------------------------------------
*Updating the only saving,current,sweep account - starts
*-------------------------------------------------

*    IF Y.WAIVE.CHG.UPD EQ '1' THEN
*        CALL F.WRITE(FN.ACCOUNT,ID,R.ACCOUNT)
*   END
    Y.STATUS.1 = R.ACCOUNT<AC.LOCAL.REF,REF.POS>
    Y.STATUS.2 = R.ACCOUNT<AC.LOCAL.REF,STATUS2.POS>

    IF Y.STATUS.UPD EQ '1' OR Y.WAIVE.CHG.UPD EQ '1' OR Y.STATUS.1 OR Y.STATUS.2 THEN

*        IF Y.CONT.FLAG THEN
*       CALL F.WRITE(FN.ACCOUNT,ID,R.ACCOUNT)

        IF Y.STATUS.1 OR Y.STATUS.2 THEN
            APP.ID = ''
            Y.AC.ST.POS<1>=REF.POS
            Y.AC.ST.POS<2>=STATUS2.POS

*CALL REDO.B.PREVELENCE.STATUS.UPD(ID,R.ACCOUNT,Y.AC.ST.POS,Y.STATUS.CHG.UPD,R.AZ.ACCOUNT)
*R22 MANUAL CONVERSION
            APAP.REDOBATCH.redoBPrevelenceStatusUpd(ID,R.ACCOUNT,Y.AC.ST.POS,Y.STATUS.CHG.UPD,R.AZ.ACCOUNT)
        END ELSE
            V = AC.AUDIT.DATE.TIME
            CALL F.LIVE.WRITE(FN.ACCOUNT,ID,R.ACCOUNT)
*       CALL F.WRITE(FN.ACCOUNT,ID,R.ACCOUNT)
        END

*Shek... is this required?
*Y.LAST.WRK.DAY.ID = Y.LAST.WRK.DAY:'-':SESSION.NO
*CALL F.READ(FN.UPD.ACC.LIST, Y.LAST.WRK.DAY.ID, *R.UPD.ACC.LIST,F.UPD.ACC.LIST,UPD.ACC.LIST.ERR)
  
        Y.TODAY = R.DATES(EB.DAT.TODAY)  ;*TSR637100  start
        Y.TODAY.ID = Y.TODAY:'-':SESSION.NO
        CALL F.READ(FN.UPD.ACC.LIST, Y.TODAY.ID, R.UPD.ACC.LIST,F.UPD.ACC.LIST,UPD.ACC.LIST.ERR)  ;*TSR637100  end

        R.UPD.ACC.LIST<-1>=ID
*CALL F.WRITE(FN.UPD.ACC.LIST, Y.LAST.WRK.DAY.ID, R.UPD.ACC.LIST)

        CALL F.WRITE(FN.UPD.ACC.LIST, Y.TODAY.ID, R.UPD.ACC.LIST) ;*TSR637100
*Shek -end
*        CALL F.RELEASE(FN.UPD.ACC.LIST,Y.LAST.WRK.DAY, F.UPD.ACC.LIST)
*        END

    END
    GOSUB UPD.PRD.TABLE.CHECK
RETURN
*--------------
OD.CATEG.CHECK:
*--------------
*-------------------------------------------------
* Updating the only saving,current,sweep account- ends
*-------------------------------------------------
    Y.OD.CATEGORY=''          ;* Shek

    IF Y.DEPOSIT.ACCOUNT NE '' THEN     ;* Shek Read AZ/AZ$His only if account relates to deposit
        CALL CACHE.READ(FN.AZ.PRODUCT.PARAM,Y.DEPOSIT.ACCOUNT, R.AZ.PRODUCT.PARAM,PR.ERR) ;*shek cache read
        Y.OD.CATEGORY=R.AZ.PRODUCT.PARAM<AZ.APP.OD.CATEGORY>

        CALL F.READ(FN.AZ.ACCOUNT,ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
    END   ;* Shek
RETURN

*-------------------
UPD.PRD.TABLE.CHECK:
*-------------------
    Y.STATUS2.LIST = R.ACCOUNT<AC.LOCAL.REF,STATUS2.POS>
    CHANGE @SM TO @FM IN Y.STATUS2.LIST ;*R22 MANUAL CONVERSION
    GUARANTEE.POS=''
    Y.GUARANTEE.FLAG = ''
    LOCATE 'GUARANTEE.STATUS' IN Y.STATUS2.LIST SETTING GUARANTEE.POS THEN
        Y.GUARANTEE.FLAG = 1
    END
    IF Y.STATUS.UPD EQ '1'  OR Y.GUARANTEE.FLAG NE '' OR Y.OD.CATEGORY EQ R.ACCOUNT<AC.CATEGORY> THEN
        GOSUB UPD.PRD.TABLE
    END
RETURN
*-----------------------
ZERO.CHECK:
*----------------------
* Checking for availability of any one date
*---------------------------------------------
    IF LAST.DR.DT EQ '' THEN
        Y.LAST.TRANSACTION.DATE = LAST.CR.DT
    END

    IF LAST.CR.DT EQ '' THEN
        Y.LAST.TRANSACTION.DATE = LAST.DR.DT
    END
RETURN

*--------------------
FULL.CHECK:
*--------------------
* Checking for both the dates
*-----------------------------
    IF LAST.DR.DT GT LAST.CR.DT  THEN
        Y.LAST.TRANSACTION.DATE = LAST.DR.DT
    END ELSE
        Y.LAST.TRANSACTION.DATE = LAST.CR.DT
    END

RETURN

*------------START OF MODIFICATION--------------------------------------------------------
* This will update the PRD.STATUS in the local table REDO.CUST.PRD.LIST as "Inactive" when
* L.AC.STATUS1 is "6 months inactive", "3 years inactive", "abandoned"
*-----------------------------------------------------------------------------------------
UPD.PRD.TABLE:
*------------
    IF R.ACCOUNT<AC.CUSTOMER> NE '' THEN

        Y.CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
        CUST.JOIN='CUSTOMER'
        GOSUB UPD.PRD.LIST
        GOSUB PRD.UPD.JOIN
    END
RETURN

*--------------
UPD.PRD.LIST:
*-----------------
* Check if record is read earlier
    sPos = ''
    LOCATE Y.CUSTOMER.ID IN PrdIdList<1> SETTING sPos THEN
        RCustPrdList = RAISE(PrdListRec<sPos>)
    END ELSE
        CALL F.READ(FN.CUST.PRD.LIST, Y.CUSTOMER.ID, RCustPrdList, F.CUST.PRD.LIST, Err)

        PrdIdList<-1> = Y.CUSTOMER.ID
        PrdListRec<-1> = LOWER(RCustPrdList)

    END

    PrdListID = Y.CUSTOMER.ID :'-' : SESSION.NO

    Y.PRD.LIST = RCustPrdList<PRD.PRODUCT.ID>
    CHANGE @VM TO @FM IN Y.PRD.LIST ;*R22 MANUAL CONVERSION
    PRD.POS = ''
    LOCATE ID IN RCustPrdList SETTING PRD.POS THEN
        IF RCustPrdList<PRD.PRD.STATUS, PRD.POS> NE 'INACTIVE' THEN
            RCustPrdList<PRD.PRD.STATUS,PRD.POS> ='INACTIVE'
            RCustPrdList<PRD.TYPE.OF.CUST,PRD.POS>=CUST.JOIN
            RCustPrdList<PRD.DATE,PRD.POS>=Y.LAST.WRK.DAY:'*'
            RCustPrdList<PRD.PROCESS.DATE> = Y.LAST.WRK.DAY
            CALL F.WRITE(FN.CUST.PRD.LST, PrdListID, RCustPrdList)
        END
    END

RETURN


*-------------
PRD.UPD.JOIN:
*--------------
    IF R.ACCOUNT<AC.JOINT.HOLDER> NE '' THEN
        Y.CUSTOMER.ID=R.ACCOUNT<AC.JOINT.HOLDER>
        CUST.JOIN='JOINT.HOLDER'
        GOSUB UPD.PRD.LIST
    END

RETURN

*----------------
CHANGE.STATUS:
*----------------
* PACS00472936
    IF Y.PREV.SELECT.STATUS EQ "" THEN
        RETURN
    END
* PACS00472936
    IF R.ACCOUNT<AC.LOCAL.REF,REF.POS> NE Y.PREV.SELECT.STATUS OR Y.LAST.TRANSACTION.DATE GE Y.LAST.WRK.DAY THEN        ;* last working day is added for migrated contracts
        R.ACCOUNT<AC.LOCAL.REF,REF.POS>= Y.PREV.SELECT.STATUS
        Y.STATUS.UPD = 1
        Y.STATUS.CHG.UPD=1
*CALL REDO.UPD.ACCOUNT.STATUS.DATE(ID,Y.PREV.SELECT.STATUS)
*R22 MANUAL CONVERSION
        APAP.REDOAPAP.redoUpdAccountStatusDate(ID,Y.PREV.SELECT.STATUS)
    END
*PACS00308629-S
    VAR.ACCT.ID = ID
    LOCATE VAR.ACCT.ID IN R.REDO.WAIVE.LEDGER.ACCT SETTING POS.LEDGER THEN
*If waive ledger fee updated manually by user then no need for below check
        IF R.ACCOUNT<AC.WAIVE.LEDGER.FEE> NE 'Y' THEN
            R.ACCOUNT<AC.WAIVE.LEDGER.FEE> = 'Y'
            Y.WAIVE.CHG.UPD=1
        END
        RETURN
    END ELSE
*If l.ac.status.2 contains 'DECEASED' then waive ledger fee is always to be 'Y' else it will update based on l.ac.status.1
        VAR.STATUS2.LIST = R.ACCOUNT<AC.LOCAL.REF,STATUS2.POS>
        CHANGE @SM TO @FM IN VAR.STATUS2.LIST ;*R22 MANUAL CONVERSION
        LOCATE 'DECEASED' IN VAR.STATUS2.LIST SETTING POS.DEC THEN
            IF R.ACCOUNT<AC.WAIVE.LEDGER.FEE> NE 'Y' THEN
                R.ACCOUNT<AC.WAIVE.LEDGER.FEE> = 'Y'
                Y.WAIVE.CHG.UPD=1
                Y.STATUS.CHG.UPD=1
            END
        END ELSE
            IF Y.PREV.WAIVE.LEDGER EQ 'YES' THEN
                Y.PREV.WAIVE.LEDGER='Y'
            END ELSE
                Y.PREV.WAIVE.LEDGER=''
            END

            IF R.ACCOUNT<AC.WAIVE.LEDGER.FEE> NE Y.PREV.WAIVE.LEDGER THEN
                R.ACCOUNT<AC.WAIVE.LEDGER.FEE>=Y.PREV.WAIVE.LEDGER
*PACS00136023--------------------------------------START---------------------
                Y.WAIVE.CHG.UPD=1
                Y.STATUS.CHG.UPD=1
            END
        END
    END
*PACS00308629-E
RETURN

*---------------------------------- END OF MODIFICATION---------------------
END
