* @ValidationCode : Mjo4MDQxMTk3NzM6Q3AxMjUyOjE2ODA2OTc3ODc3NzA6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 17:59:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.FT.TT
    
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 05.04.2023       Conversion Tool       R22            Auto Conversion     - new condition added
* 05.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------
    

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_F.REDO.STORE.SPOOL.ID

    FN.REDO.STORE.SPOOL.ID = 'F.REDO.STORE.SPOOL.ID'
    F.REDO.STORE.SPOOL.ID = ''
    CALL OPF(FN.REDO.STORE.SPOOL.ID,F.REDO.STORE.SPOOL.ID)

    Y.DD = O.DATA
    Y.DATA = System.getVariable("CURRENT.INDA.ID")
    
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;** R22 Auto Conversion - Start
        Y.DATA = ""
    END ;** R22 Auto Conversion - End

    IF Y.DATA EQ 'CURRENT.INDA.ID' THEN
        RETURN
    END ELSE
        CALL F.READ(FN.REDO.STORE.SPOOL.ID,Y.DATA,R.REDO.STORE.SPOOL.ID,F.REDO.STORE.SPOOL.ID,SPL.ERR)
        IF R.REDO.STORE.SPOOL.ID THEN
*      LOCATE Y.DD IN R.REDO.STORE.SPOOL.ID<1,1> SETTING POS THEN
* Tus Start
            LOCATE Y.DD IN R.REDO.STORE.SPOOL.ID<RD.SPL.SPOOL.ID,1> SETTING POS THEN
* Tus End
                O.DATA = Y.DATA
            END
        END
    END

RETURN

END
