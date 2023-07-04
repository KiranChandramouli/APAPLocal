* @ValidationCode : MjoyMzQ2OTQyNTQ6Q3AxMjUyOjE2ODI0MTIzMzg4NjM6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:38
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
SUBROUTINE REDO.V.AUTH.DEAL.PRINT
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2009-10-0547
* This is the authorisation routine to choose which deal slip to be triggered

* Revision History:
*------------------------------------------------------------------------------------------
* Date who Reference Description
* 28-Dec-2009 SHANKAR RAJU Initial Creation
*------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*10-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*10-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------
 
 
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DEAL.SLIP.FORMAT
    $INSERT I_GTS.COMMON

    GOSUB INIT
    GOSUB PROCESS
RETURN

*************
INIT:
*************
    CUST.ID=ID.NEW
    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    LREF.FLD="L.CU.TIPO.CL"

    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN

*********
PROCESS:
*********



    CALL GET.LOC.REF('CUSTOMER',LREF.FLD,TIPO.POS)

    OFS$DEAL.SLIP.PRINTING = 1
    V$FUNCTION = "A"
    SAVE.APPLICATION = APPLICATION
    APPLICATION = "CUSTOMER"


    IF R.NEW(EB.CUS.LOCAL.REF)<1,TIPO.POS> EQ 'PERSONA FISICA' THEN

        CALL PRODUCE.DEAL.SLIP("CUS.KYC.FORM.1")

    END
    IF R.NEW(EB.CUS.LOCAL.REF)<1,TIPO.POS> EQ 'PERSONA JURIDICA' THEN

        CALL PRODUCE.DEAL.SLIP("CUS.KYC.FORM.2")

    END


RETURN
**************
END
