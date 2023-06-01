* @ValidationCode : MjotNDQwNTU3MTQ1OkNwMTI1MjoxNjgxODI5MDg3Mzc0OklUU1M6LTE6LTE6Mzc5OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 20:14:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 379
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*12-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM
*12-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
SUBROUTINE REDO.CUS.ACC.PRPSD.USE(CUST.ID,DEPOSIT.SOURCE)
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* This subroutine is to check the relation code and proceeed accordingly
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY : DEPOSIT.SOURCE
*
* Revision History:
*------------------------------------------------------------------------------------------
* Date who Reference Description
* 25-DEC-2009 ODR-2010-04-0425 B Renugadevi Initial Creation
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER.ACCOUNT
    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    CUS.ID = CUST.ID
    CNT = ''
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    DEPOSIT.SOURCE = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    CALL GET.LOC.REF('ACCOUNT','L.AC.PROP.USE',L.PROP.POS)
RETURN
********
PROCESS:
********
    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUS.ID,R.CUST,F.CUSTOMER.ACCOUNT,CUST.ERR)
    CNT = DCOUNT(R.CUST,@FM)
    INC = 1
    LOOP
    WHILE INC LE CNT
        ACC.ID = R.CUST<INC>
        GOSUB READ.VALUES
        INC +=1
    REPEAT
    CHANGE @FM TO @VM IN DEPOSIT.SOURCE
RETURN
***********
READ.VALUES:
***********
    CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACC,F.ACCOUNT,ACC.ERR)
    IF R.ACC THEN
        PROP.CODE = R.ACC<AC.LOCAL.REF,L.PROP.POS>
        ACCT.CODE = ACC.ID
        DEPOSIT.SOURCE<-1> = ACCT.CODE:":":PROP.CODE:"@"
    END
RETURN
END
