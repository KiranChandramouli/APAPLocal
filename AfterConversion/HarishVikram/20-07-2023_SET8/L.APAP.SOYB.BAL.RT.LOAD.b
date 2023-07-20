$PACKAGE APAP.LAPAP
* @ValidationCode : MjoxMTY0NTAxOTg3OkNwMTI1MjoxNjg5ODMyMzE3Mzg0OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Jul 2023 11:21:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.SOYB.BAL.RT.LOAD
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       No changes
* 13-07-2023     Harishvikram C   Manual R22 conversion       BP Removed, EXECUTE INITIALISED
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.ACCOUNT
    $INSERT  I_F.DATES
    $INSERT  I_F.ST.L.APAP.SOYB
    $INSERT  I_APAP.SOYB.BAL.COMMON

    GOSUB INITIAL

RETURN

INITIAL:
    FN.AC = "F.ACCOUNT"
    F.AC = ""
    CALL OPF(FN.AC,F.AC)
    FN.SOYB = "FBNK.ST.L.APAP.SOYB"
    F.SOYB = ""
    CALL OPF(FN.SOYB,F.SOYB)
    Y.FECHA = R.DATES(EB.DAT.TODAY)
    
*    EXECUTE("CLEAR.FILE FBNK.ST.L.APAP.SOYB")                        ;*Manual R22 conversion - Start
*    EXECUTE("CLEAR.FILE FBNK.ST.L.APAP.SOYB$HIS")
    
    Y.EXC.CMD = "CLEAR.FILE FBNK.ST.L.APAP.SOYB"
    Y.EXC.CMD1 = "CLEAR.FILE FBNK.ST.L.APAP.SOYB$HIS"
    
    EXECUTE Y.EXC.CMD1
    EXECUTE Y.EXC.CMD1                                              ;*Manual R22 conversion - End


RETURN

END
