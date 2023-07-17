* @ValidationCode : MjotMTI5NDcxNzYxNDpDcDEyNTI6MTY4MDc4MzY2NjQ1MjpJVFNTOi0xOi0xOjc5OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:51:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 79
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
******************************************************************************
SUBROUTINE REDO.FC.PROD.DESC
******************************************************************************
* Company Name:   Asociacion Popular de Ahorro y Prestamo (APAP)
* Developed By:   Reginal Temenos Application Management
*-----------------------------------------------------------------------------
* Subroutine Type :  BUILD ROUTINE
* Attached to     :  ENQUIRY > REDO.FC.E.CUST.AA
* Attached as     :  CONVERSION
* Primary Purpose :  Obtiene la descripcion de un producto AA
*
* Incoming        :  NA
* Outgoing        :  NA
*
*-----------------------------------------------------------------------------
* Modification History:
* ====================
* Development by  : lpazminodiaz@temenos.com
* Date            : 23/08/2011
* Purpose         : Initial version
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
******************************************************************************

******************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.PRODUCT

    $INSERT I_F.REDO.CREATE.ARRANGEMENT

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* ========
INITIALISE:
* ========
    FN.AA.PRODUCT = 'F.AA.PRODUCT'
    F.AA.PRODUCT = ''
    R.AA.PRODUCT = ''

    Y.ERR = ''

RETURN

* ========
OPEN.FILES:
* ========
    CALL OPF(FN.AA.PRODUCT,F.AA.PRODUCT)

RETURN

* =====
PROCESS:
* =====
    Y.PRODUCT.ID = R.RECORD<REDO.FC.PRODUCT>
    CALL CACHE.READ(FN.AA.PRODUCT,Y.PRODUCT.ID,R.AA.PRODUCT,Y.ERR)

    Y.PRODUCT.DESCRIPTION = FIELD(R.AA.PRODUCT<AA.PDT.DESCRIPTION>,@VM,2)
    IF Y.PRODUCT.DESCRIPTION EQ '' THEN
        Y.PRODUCT.DESCRIPTION = FIELD(R.AA.PRODUCT<AA.PDT.DESCRIPTION>,@VM,1)
    END

    O.DATA = Y.PRODUCT.DESCRIPTION

RETURN

END
