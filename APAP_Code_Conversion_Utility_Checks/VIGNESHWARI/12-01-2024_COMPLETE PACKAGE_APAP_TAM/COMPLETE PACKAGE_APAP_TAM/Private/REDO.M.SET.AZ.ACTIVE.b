* @ValidationCode : MjotMTMwOTA5MTEyMDpVVEYtODoxNzA0OTU0Nzg4NjU2OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Jan 2024 12:03:08
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.M.SET.AZ.ACTIVE
*-------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.M.SET.AZ.ACTIVE
*DESCRIPTION:Mainline routine to set AZ account status to Active
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : Y.PGM.ID
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date             who                 Reference                     Description
*  ------           --------          ---------------                  ------------------
* 24-07-2012     Prabhu N                                             Initial Creation
* 13.04.2023     Conversion Tool             R22                      Auto Conversion     - FM TO @FM, VM TO @VM, ++ TO += 1
* 13.04.2023    Shanmugapriya M             R22                      Manual Conversion   - No changes
*
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CUST.PRD.LIST
    $USING EB.TransactionControl


    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT =''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.AZ.CUSTOMER='F.AZ.CUSTOMER'
    F.AZ.CUSTOMER =''
    CALL OPF(FN.AZ.CUSTOMER,F.AZ.CUSTOMER)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT =''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)


    FN.PRD.LIST='F.REDO.CUST.PRD.LIST'
    F.PRD.LIST =''
    CALL OPF(FN.PRD.LIST,F.PRD.LIST)

    LRF.FIELD='L.AC.STATUS1'
    LRF.APP  ='ACCOUNT'
    LRF.POS  =''
    CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)

    SEL.CMD="SELECT ":FN.AZ.CUSTOMER

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.CUST,ERR)

    Y.CUST.CNT=1
    LOOP
    WHILE Y.CUST.CNT LE NO.CUST
        CALL F.READ(FN.AZ.CUSTOMER,SEL.LIST<Y.CUST.CNT>,R.AZ.CUSTOMER,F.AZ.CUSTOMER,ERR)
        GOSUB AZ.UPDATE
        Y.CUST.CNT += 1            ;** R22 Auto conversion - ++ TO += 1
    REPEAT
*    CALL JOURNAL.UPDATE('')
    EB.TransactionControl.JournalUpdate('');* R22 UTILITY AUTO CONVERSION
RETURN
AZ.UPDATE:
    NO.REC=DCOUNT(R.AZ.CUSTOMER,@FM)
    Y.REC.CNT=1
    Y.CUST.ID  =SEL.LIST<Y.CUST.CNT>
*    CALL F.READ(FN.PRD.LIST,Y.CUST.ID,R.PRD.LIST,F.PRD.LIST,ERR)
    CALL F.READU(FN.PRD.LIST,Y.CUST.ID,R.PRD.LIST,F.PRD.LIST,ERR,'');* R22 UTILITY AUTO CONVERSION
    Y.ACCT.LIST=R.PRD.LIST<PRD.PRODUCT.ID>
    CHANGE @VM TO @FM IN Y.ACCT.LIST
    LOOP
    WHILE Y.REC.CNT LE NO.REC
*        CALL F.READ(FN.ACCOUNT,R.AZ.CUSTOMER<Y.REC.CNT>,R.ACCOUNT,F.ACCOUNT,ERR)
        CALL F.READU(FN.ACCOUNT,R.AZ.CUSTOMER<Y.REC.CNT>,R.ACCOUNT,F.ACCOUNT,ERR,'');* R22 UTILITY AUTO CONVERSION
        IF R.ACCOUNT THEN
            R.ACCOUNT<AC.LOCAL.REF,LRF.POS>='ACTIVE'
            CALL F.WRITE(FN.ACCOUNT,SEL.LIST<Y.REC.CNT>,R.ACCOUNT)
            LOCATE R.AZ.CUSTOMER<Y.REC.CNT> IN Y.ACCT.LIST SETTING POS THEN
                R.PRD.LIST<PRD.PRD.STATUS,POS>='ACTIVE'
            END
        END
        Y.REC.CNT += 1                ;** R22 Auto conversion - ++ TO += 1
    REPEAT
    CALL F.WRITE(FN.PRD.LIST,Y.CUST.ID,R.PRD.LIST)
RETURN
END
