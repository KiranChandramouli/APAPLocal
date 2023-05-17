SUBROUTINE REDO.E.NOFILE.SAV.CUR.ACCT(Y.FINAL.ARRAY)
**************************************************************************************************
*-------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Bharath G
* Program Name : REDO.E.NOFILE.SAV.CUR.ACCT
*--------------------------------------------------------------------------------
*Description :This subroutine is attached to the ENQUIRY REDO.AZ.ACCOUNT.SEL
*             which displays the current and savings account.
*--------------------------------------------------------------------------------
* Linked With   : ENQUIRY REDO.ENQ.CUSTOMER.SEGMENT
* In Parameter  : None
* Out Parameter : None
*---------------------------------------------------------------------------------
*Modification History:
*------------------------
*     Date            Who                  Reference              Description
*    ------          ------               -----------             --------------
*   19-10-2010       Bharath G            PACS0085750             Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_System

    GOSUB INIT
    GOSUB PROCESS

INIT:
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN

PROCESS:

    Y.CUST.VAL = System.getVariable('CURRENT.CUSTOMER.ID')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.CUST.VAL = ""
    END

    SEL.CMD="SELECT ":FN.ACCOUNT:" WITH ((CATEGORY BETWEEN '6000' '6599') OR (CATEGORY BETWEEN '1000' '1999')) AND CUSTOMER EQ ":Y.CUST.VAL
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,AZ.ERR)

    LOOP
        REMOVE SEL.ID FROM SEL.LIST SETTING POS
    WHILE SEL.ID:POS
        CALL F.READ(FN.ACCOUNT,SEL.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
        IF R.ACCOUNT THEN
            Y.FINAL.ARRAY<-1> = SEL.ID:"*":R.ACCOUNT<AC.SHORT.TITLE>:"*":R.ACCOUNT<AC.CURRENCY>
        END
    REPEAT

RETURN
************************************************************
END
