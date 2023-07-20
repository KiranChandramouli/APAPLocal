* @ValidationCode : MjoxMzY4NDI0NTkxOkNwMTI1MjoxNjg5NzY1OTYzMTExOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Jul 2023 16:56:03
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
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.SCHEDULE.PROJ.LOAD
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : L.APAP.SCHEDULE.PROJ
*--------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO               DESCRIPTION
*  20200530         ELMENDEZ              INITIAL CREATION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       EXECUTE variable initialised
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_L.APAP.SCHEDULE.PROJ.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.EB.L.APAP.SCHEDULE.PROJET
*-----------------------------------------------------------------------------
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    FN.AA.ARRANGEMENT<2> = 'NO.FATAL.ERROR'
    F.AA.ARRANGEMENT = ''


    FN.SCHEDULE.PROJ = 'F.EB.L.APAP.SCHEDULE.PROJET'
    FN.SCHEDULE.PROJ<2> = 'NO.FATAL.ERROR'
    F.SCHEDULE.PROJ  = ''

    Y.TODAY = TODAY

    CALL OPF(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)
    CALL OPF(FN.SCHEDULE.PROJ , F.SCHEDULE.PROJ)


*    EXECUTE("CLEAR.FILE FBNK.EB.L.APAP.SCHEDULE.PROJET")            ;*Manual R22 conversion - Start
    Y.EXC.CMD = "CLEAR.FILE FBNK.EB.L.APAP.SCHEDULE.PROJET"
    EXECUTE Y.EXC.CMD                                                ;*Manual R22 conversion - End
    CALL OCOMO("TABLA DE DATOS BORRADA FBNK.EB.L.APAP.SCHEDULE.PROJET")


    CALL OCOMO("SE EJECUTO>L.APAP.L.APAP.SCHEDULE.PROJ.LOAD")
RETURN
END
