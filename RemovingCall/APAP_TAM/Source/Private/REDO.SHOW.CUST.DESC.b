* @ValidationCode : MjotMTY0ODg0NDEyODpDcDEyNTI6MTY4NDg0MjEzMTIzODpJVFNTOi0xOi0xOjM4NToxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 385
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.SHOW.CUST.DESC(CUST.ID,STATUS.DESC)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* This subroutine is to return the Customer Description
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY : STATUS.DESC
*
* Revision History:
*------------------------------------------------------------------------------------------
* Date              who           Reference            Description
* 25-Nov-2009       B Renugadevi  ODR-2010-04-0425     Initial creation
*------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*18-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*18-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CUSTOMER.STATUS

    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    CUST.STATUS=''
    CUS.ID=CUST.ID
    FN.CUSTOMER='F.CUSTOMER'
    FN.CUSTOMER.STATUS='F.CUSTOMER.STATUS'
    F.CUSTOMER=''
    F.CUSTOMER.STATUS=''
    R.CUSTOMER.STATUS=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.CUSTOMER.STATUS,F.CUSTOMER.STATUS)

RETURN
*********
PROCESS:
********

    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    IF R.CUSTOMER THEN
        CUST.STATUS=R.CUSTOMER<EB.CUS.CUSTOMER.STATUS>
    END
    IF CUST.STATUS NE '' THEN
        CALL F.READ(FN.CUSTOMER.STATUS,CUST.STATUS,R.CUSTOMER.STATUS,F.CUSTOMER.STATUS,ERR.CUST)
        IF R.CUSTOMER.STATUS THEN
            STATUS.DESC=R.CUSTOMER.STATUS<EB.CST.DESCRIPTION>
        END
    END ELSE
        STATUS.DESC=''
    END
RETURN

END
*-----------------------------------------------------------------------------------------
