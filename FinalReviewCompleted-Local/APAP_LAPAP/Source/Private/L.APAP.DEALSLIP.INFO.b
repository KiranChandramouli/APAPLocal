* @ValidationCode : MjotMTM5NzM2MTc1MjpDcDEyNTI6MTY4MjMzMTMyMTIyMDpJVFNTOi0xOi0xOjk5OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 99
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.DEALSLIP.INFO(Y.INP.DEAL)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       F.READ to CACHE.READ, BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.L.NCF.STOCK ;*R22 Auto conversion - END
 
*--PARA ABRIR EL ACHIVO REDO.L.NCF.STOCK
    FN.NCF = "FBNK.REDO.L.NCF.STOCK"
    FV.NCF = ""
    RS.NCF = ""
    NCF.ERR = ""

    CALL OPF(FN.NCF, FV.NCF)
    CALL CACHE.READ(FN.NCF, 'SYSTEM', RS.NCF, NCF.ERR) ;*R22 Auto conversion
    NCF.EXPIRED.DATE = RS.NCF<ST.L.EXPIRED.DATE>

    FORMAT.DATE = SUBSTRINGS(NCF.EXPIRED.DATE,7,2) : "/" : SUBSTRINGS(NCF.EXPIRED.DATE,5,2) : "/" : SUBSTRINGS(NCF.EXPIRED.DATE,3,2)
    Y.INP.DEAL = FMT(FORMAT.DATE, "8R")

RETURN


END
