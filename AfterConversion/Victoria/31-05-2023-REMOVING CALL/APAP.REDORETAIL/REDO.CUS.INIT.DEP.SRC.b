* @ValidationCode : MjotMzY2MzY3NTMwOkNwMTI1MjoxNjgxODI5MDg5NDk0OklUU1M6LTE6LTE6Mjc3OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 20:14:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 277
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*12-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 FM TO @FM
*12-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
SUBROUTINE REDO.CUS.INIT.DEP.SRC(CUST.ID,DEPOSIT.SOURCE)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* This is field format routine for the pdf form CUS.KYC.FORM
* Input/Output:
*--------------
* IN :CUSTOMER.ID
* OUT : DEPOSIT.SOURCE1
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------------------------------------------------------------------------------
* Date who Reference Description
* 28-DEC-2009 B Renugadevi ODR-2010-04-0425 Initial Creation
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER.ACCOUNT
    GOSUB INIT
    GOSUB PROCESS
RETURN
*
******
INIT:
******
    CNT = ''
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    DEPOSIT.SOURCE = ''
    DEPOSIT.CODE = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL GET.LOC.REF('ACCOUNT','L.AC.SRCINITDEP',L.DEP.POS)


    CUS.ID = CUST.ID
RETURN
********
PROCESS:
********
*
    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUS.ID,R.CUST,F.CUSTOMER.ACCOUNT,CUST.ERR)
    CNT = DCOUNT(R.CUST,@FM)
    INC = 1
    LOOP
    WHILE INC LE CNT
        ACC.ID = R.CUST<INC>
        GOSUB READ.VALUES
        INC +=1
    REPEAT
RETURN
************
READ.VALUES:
************
    CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT THEN
        DEP.CODE = R.ACCOUNT<AC.LOCAL.REF,L.DEP.POS>
        ACCT.CODE = ACC.ID
        DEPOSIT.SOURCE<-1> = ACCT.CODE:":":DEP.CODE:"@"
    END
RETURN
END
