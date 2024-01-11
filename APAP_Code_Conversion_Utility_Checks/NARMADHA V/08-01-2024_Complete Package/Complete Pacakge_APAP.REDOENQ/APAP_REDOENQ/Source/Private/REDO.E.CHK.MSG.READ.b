* @ValidationCode : MjotOTg5MjYyMjIzOlVURi04OjE3MDM1NzIzNTI0MTA6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Dec 2023 12:02:32
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
$PACKAGE APAP.REDOENQ
* Subroutine type : Subroutine
* Attached to     : Enquiry AI.MESSAGE.READ.IN
* Attached as     : BUILD Routine
* Incoming        : ENQ.DATA Common varible
* outgoing        : ENQ.DATA
* Purpose         : To change the Message status to "READ"
*                 :
*                 : to the common variable O.DATA
* @author         : madhusudananp@temenos.com
* Change History  :
* Version         : First version

*================================================================================================
SUBROUTINE REDO.E.CHK.MSG.READ
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion  -  Added IF E EQ "EB-UNKNOWN.VARIABLE"
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 26-12-2023         Narmadha V            Manual R22 Conversion - F.READ to F.READU
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.SECURE.MESSAGE
    $INSERT I_System

*    MSG.ID = ENQ.DATA<4,1>

    MSG.ID = System.getVariable("CURRENT.MSG.ID")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN     ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE"
        MSG.ID = ""
    END
    FnEsm = 'F.EB.SECURE.MESSAGE'
    FEsm = ''

    OPEN FnEsm TO F.ESM THEN



*    READ RecEsm FROM F.ESM,MSG.ID THEN ;*Tus Start
*CALL F.READ(FnEsm,MSG.ID,RecEsm,F.ESM,RecEsm.ERR)
        CALL F.READU(FnEsm,MSG.ID,RecEsm,F.ESM,RecEsm.ERR,'') ;*Manual R22 Conversion - F.READ to F.READU
        IF RecEsm THEN  ;* Tus End
            RecEsm<EB.SM.TO.STATUS> = "READ"

*      WRITE RecEsm TO F.ESM,MSG.ID ;*Tus Start
            CALL F.WRITE(FnEsm,MSG.ID,RecEsm);* Tus End
        END
    END
RETURN
