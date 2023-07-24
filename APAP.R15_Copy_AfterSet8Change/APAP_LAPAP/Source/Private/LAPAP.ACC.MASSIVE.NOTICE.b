* @ValidationCode : MjoxNDIxNjI3MDkwOkNwMTI1MjoxNjkwMTc5NTMxNDA0OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Jul 2023 11:48:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*========================================================================
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.ACC.MASSIVE.NOTICE(SEL.LIST)
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.ACC.MASSIVE.NOTICE
* Date           : 2019-05-21
* Item ID        : --------------
*========================================================================
* Brief description :
* -------------------
* This program allow ....
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2019-05-21     Richard HC        Initial Development
*========================================================================
* Content summary :
* =================
* Table name     :F.ACCOUNT
* Auto Increment :N/A
* Views/versions :
* EB record      :N/A
* Routine        :LAPAP.ACC.MASSIVE.NOTICE
*========================================================================
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 13-JULY-2023      Harsha                R22 Auto Conversion  - VM to @VM , S to S.VAR , M to M.VAR
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_LAPAP.ACC.MASSIVE.NOTICE.COMMON

*   ACC.ID = SEL.LIST

    CALL OCOMO(SEL.LIST)

    F.ID = EREPLACE(SEL.LIST,",",@VM)
    FILE.ARR = DCOUNT(F.ID,@VM)

    ACC.ID = F.ID<1,1>
    MSG = F.ID<1,2>
    COMMENT = F.ID<1,3>


    R.SS = "";
    CALL F.READ(FN.ACC,ACC.ID,R.ACC,F.ACC,ERR.ACC)
    CALL GET.LOC.REF("ACCOUNT","L.AC.NOTIFY.1",POS)
    CALL GET.LOC.REF("ACCOUNT","L.AC.NOTIFY.2",PO2)

    PREVIOUS.NOTICE = R.ACC<AC.LOCAL.REF,POS>
    M.VAR = DCOUNT(PREVIOUS.NOTICE,@SM)		;*R22 Auto Conversion  - M to M.VAR
    S.VAR = M.VAR+1				;*R22 Auto Conversion  - S to S.VAR

*   DEBUG

    APP = "ACCOUNT"
    ID = ACC.ID
    Y.FUNC = "I"
    R.SS<AC.LOCAL.REF,POS,S.VAR> = MSG		;*R22 Auto Conversion  - S to S.VAR
    R.SS<AC.LOCAL.REF,PO2,S.VAR> = COMMENT	;*R22 Auto Conversion  - S to S.VAR
*   CALL LAPAP.BUILD.OFS.LOAD(APP,Y.FUNC,ID,R.SS)

    IF ERR.ACC THEN ;* OR ID EQ 0 THEN

        IF ID NE 0 THEN
            ARR<1> = "LAPAP.ACC.MASSIVE.NOTICE.REJECTED.txt"
            ARR<2> = "NO SE PUDO MODIFICAR EL STATUS DE LA CUENTA.( ":ID:" ) ":ERR.ACC
            ARR<3> = "../interface/T24ACCNOTICE"
*CALL LAPAP.WRITE.FILE(ARR)
            APAP.LAPAP.lapapWriteFile(ARR);* R22 Manual conversion - CALL method format changed
        END

    END ELSE
*CALL LAPAP.BUILD.OFS.LOAD(APP,Y.FUNC,ID,R.SS)
        APAP.LAPAP.lapapBuildOfsLoad(APP,Y.FUNC,ID,R.SS);* R22 Manual conversion - CALL method format changed
    END


RETURN

END
