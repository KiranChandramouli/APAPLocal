*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
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
*-----------------------------------------------------------------------------
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE LAPAP.BP I_L.APAP.SCHEDULE.PROJ.COMMON
    $INCLUDE T24.BP I_F.AA.ARRANGEMENT
    $INCLUDE BP I_F.EB.L.APAP.SCHEDULE.PROJET
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


    EXECUTE("CLEAR.FILE FBNK.EB.L.APAP.SCHEDULE.PROJET")
    CALL OCOMO("TABLA DE DATOS BORRADA FBNK.EB.L.APAP.SCHEDULE.PROJET")


    CALL OCOMO("SE EJECUTO>L.APAP.L.APAP.SCHEDULE.PROJ.LOAD")
    RETURN
END
