* @ValidationCode : MjoxMzc5NzEzMzMwOkNwMTI1MjoxNjgyNDEyMzI0NjQwOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUT.ACCOUNT.CLOSE
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is attached with VERSION.CONTROL of CUSTOMER.It will assign PRD.STATUS in
*REDO.CUST.PRD.LIST to closed when ACCOUNT.CLOSURE record is authorized
*------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who                      Reference                        Description
* 27-DEC-2009        Prabhu.N                ODR-2009-10-0535                 Initial Creation
* 20-AUG-2011        Ganesh R                  PACS00104446                  Changed the routine to updated Customer and Joint Customer record also
*04-04-2023           Conversion Tool          R22 Auto Code conversion      FM TO @FM,VM TO @VM , ++ TO =1
*04-04-2023            Samaran T              Manual R22 Code Conversion      No Changes
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CUST.PRD.LIST

    GOSUB INIT
    GOSUB PROCESS
RETURN
*----
INIT:
*----

    Y.INIT = 1

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF (FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNTHIS = 'F.ACCOUNT$HIS'
    F.ACCOUNTHIS  = ''
    CALL OPF(FN.ACCOUNTHIS,F.ACCOUNTHIS)

    FN.CUST.PRD.LIST='F.REDO.CUST.PRD.LIST'
    F.CUST.PRD.LIST=''
    CALL OPF(FN.CUST.PRD.LIST,F.CUST.PRD.LIST)
    Y.PRD.LIST=''
RETURN
*-------
PROCESS:
*-------
*  READ R.ACCOUNT FROM F.ACCOUNT,ID.NEW THEN ;*Tus Start
    CALL F.READ(FN.ACCOUNT,ID.NEW,R.ACCOUNT,F.ACCOUNT,R.ACCOUNT.ERR)
    IF R.ACCOUNT AND R.ACCOUNT NE 'DELETE' THEN         ;* Tus End

    END ELSE
*        CALL F.READ(FN.ACCOUNT,ID.NEW,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR)
        ACCT.ID.H = ID.NEW
        CALL EB.READ.HISTORY.REC(F.ACCOUNTHIS, ACCT.ID.H, R.ACCOUNT, AC.ERR)
    END

    Y.CUSTOMER.ID=R.ACCOUNT<AC.CUSTOMER>
    GOSUB READ.PRD
    Y.PRD.LIST=R.CUST.PRD.LIST<PRD.PRODUCT.ID>
    CHANGE @VM TO @FM IN Y.PRD.LIST ;*R22 Auto Code conversion
    LOCATE ID.NEW IN Y.PRD.LIST SETTING PRD.POS THEN
        R.CUST.PRD.LIST<PRD.DATE,PRD.POS>=TODAY
        R.CUST.PRD.LIST<PRD.PROCESS.DATE> = TODAY
        R.CUST.PRD.LIST<PRD.PRD.STATUS,PRD.POS> ='CLOSED'
        CALL F.WRITE(FN.CUST.PRD.LIST,Y.CUSTOMER.ID,R.CUST.PRD.LIST)
    END

    Y.GET.JOIN.LIST = R.ACCOUNT<AC.JOINT.HOLDER>
    Y.JOIN.CNT = DCOUNT(Y.GET.JOIN.LIST,@VM) ;*R22 Auto Code conversion
    Y.JOIN.INIT = 1
    LOOP
        REMOVE Y.JOIN.ID FROM Y.GET.JOIN.LIST SETTING Y.JOIN.POS
    WHILE Y.JOIN.INIT LE Y.JOIN.CNT
        Y.CUSTOMER.ID = Y.JOIN.ID
        GOSUB READ.PRD
        Y.PRD.LIST=R.CUST.PRD.LIST<PRD.PRODUCT.ID>
        CHANGE @VM TO @FM IN Y.PRD.LIST ;*R22 Auto Code conversion
        LOCATE ID.NEW IN Y.PRD.LIST SETTING JOIN.POS THEN
            R.CUST.PRD.LIST<PRD.DATE,JOIN.POS>=TODAY
            R.CUST.PRD.LIST<PRD.PRD.STATUS,JOIN.POS> ='CLOSED'
            CALL F.WRITE(FN.CUST.PRD.LIST,Y.CUSTOMER.ID,R.CUST.PRD.LIST)
        END
        Y.JOIN.INIT += 1 ;*R22 Auto Code conversion
    REPEAT

RETURN

*--------
READ.PRD:
*--------
    R.CUST.PRD.LIST = ''
    CALL F.READ(FN.CUST.PRD.LIST,Y.CUSTOMER.ID,R.CUST.PRD.LIST,F.CUST.PRD.LIST,CUS.ERR)
RETURN

END
