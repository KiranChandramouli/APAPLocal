*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.STATUS.UPDATE.CS(Y.CUST.ID)
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This Batch routine will update the value of CUSTOMER.STATUS field in customer
* Revision History:
*------------------
*   Date               who           Reference            Description
*
*---------------------------------------------------------------------------------------------
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_F.CUSTOMER
    $INCLUDE T24.BP I_F.ACCOUNT
    $INCLUDE TAM.BP I_F.REDO.CUST.PRD.LIST
    $INCLUDE LAPAP.BP I_REDO.B.STATUS.UPDATE.CS.COMMON

    GOSUB INIT
    IF CUST.TYPE NE 'PROSPECT' THEN
        GOSUB UPD.CC.STATUS
        GOSUB WR.CUST
    END
    RETURN
*-----
INIT:
*----
    R.CUST.PRD.LIST=''; Y.CUST.STATUS.LIST=''; Y.CUST.STATUS=''; CUST.TYPE = ''; CUS.ERR = ''
    ERR.CUSTOMER.ACCOUNT = ''; R.CUSTOMER.ACCOUNT = ''; YDECEAS.FLG = 0
    CALL F.READ(FN.CUSTOMER,Y.CUST.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERROR)
    CUST.TYPE = R.CUSTOMER<EB.CUS.CUSTOMER.TYPE>
    RETURN

*-------------
UPD.CC.STATUS:
*-------------
    CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.CUST.ID,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,ERR.CUSTOMER.ACCOUNT)
    LOOP
        REMOVE YACCT.ID FROM R.CUSTOMER.ACCOUNT SETTING CUS.POSN
    WHILE YACCT.ID:CUS.POSN
        ACCT.ERR = ''; R.ACCOUNT = '';YAC.STATUS = ''
        CALL F.READ(FN.ACCOUNT,YACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
        YAC.STATUS = R.ACCOUNT<AC.LOCAL.REF,AC.STATUS2.POS>
        CHANGE SM TO FM IN YAC.STATUS
        LOCATE 'DECEASED' IN YAC.STATUS SETTING ACT.ST.POS THEN
            YDECEAS.FLG = 1
        END ELSE
            YDECEAS.FLG = 0
            RETURN
        END
    REPEAT
    RETURN

*-------
WR.CUST:
*-------
    IF YDECEAS.FLG EQ 1 THEN
        R.CUSTOMER<EB.CUS.CUSTOMER.STATUS> = "3"
        CALL F.WRITE(FN.CUSTOMER,Y.CUST.ID,R.CUSTOMER)
        CALL JOURNAL.UPDATE(Y.CUST.ID)
        CRT "Updated the Cliente ":Y.CUST.ID
    END
    RETURN
END
