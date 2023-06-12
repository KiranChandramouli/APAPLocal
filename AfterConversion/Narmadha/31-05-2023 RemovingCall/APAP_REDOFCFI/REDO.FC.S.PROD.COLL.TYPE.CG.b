* @ValidationCode : MjoxNDg5NTQ1MDUyOlVURi04OjE2ODU1MjcwMTU1NDM6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 15:26:55
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
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.S.PROD.COLL.TYPE.CG(ENQ.DATA)
*-----------------------------------------------------------------------------
* Developer    : Jorge Valarezo (jvalarezoulloa@temenos.com)
* Date         : 03.12.2012
* Description  : NOFILE Enquiry Routine para Clase de Garantia en Template FC
* Attached to  : Enquiry REDO.FC.PROD.COLL.TYPE attached in MANUAL.CG version
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date            Who               Reference      Description
* 05-APRIL-2023      Conversion Tool       R22 Auto Conversion - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN  Y.PRODUCT = ""
* 05-APRIL-2023      Harsha                R22 Manual Conversion - call routine format modified
*------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Input/Output: NA/ENQ.DATA (Enquiry Data Result)
* Dependencies: NA
*-----------------------------------------------------------------------------

* <region name="INCLUDES">
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON

    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COLLATERAL.TYPE

    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.FC.PROD.COLL.POLICY
    $INSERT I_System
* </region>


    GOSUB INIT
    GOSUB PROCESS

RETURN

* <region name="GOSUBS">
*************
INIT:
* Initialize
*************
    Y.PRODUCT = System.getVariable("CURRENT.PRODUCT")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN      ;*R22 Auto Conversion
        Y.PRODUCT = ""                      ;*R22 Auto Conversion
    END                                     ;*R22 Auto Conversion

    LOCATE '@ID' IN D.FIELDS SETTING Y.POS THEN
        Y.COLL.CODE = D.RANGE.AND.VALUE<Y.POS>
    END

    Y.INFO <1> = Y.PRODUCT
    Y.INFO <2> = Y.COLL.CODE
RETURN


***************
PROCESS:
* Main Process
***************


    APAP.REDOFCFI.redoFcSGetCollTypeCg(Y.INFO,ENQ.DATA) ;* R22 Manual Conversion
RETURN


RETURN
* </region>

END
