SUBROUTINE REDO.APAP.PARAM.PURGE(Y.PURGE.ID)
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TEMENOS DEVELOPMENT
* Program Name  : REDO.APAP.PARAM.PURGE
* ODR           : ODR-2011-03-0113
*------------------------------------------------------------------------------------------
*DESCRIPTION  : REDO.APAP.PARAM.PURGE Multithreading routine responsible for purging TT & FT records
*------------------------------------------------------------------------------------------
* Linked with:
* In parameter : None
* out parameter : None
*------------------------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------------------------
***********************************************************************
*DATE                WHO                   REFERENCE         DESCRIPTION
*14-04-2011         JANANI             ODR-2011-03-0113     INITIAL CREATION
**********************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.PARAM.COMMON
    $INSERT I_F.REDO.FT.HIS
    $INSERT I_F.REDO.TT.HIS
    $INSERT I_F.REDO.APAP.PARAM
    $INSERT I_BATCH.FILES

    GOSUB PROCESS
RETURN
*******
PROCESS:
**********
    IF CONTROL.LIST<1,1> NE '' THEN
        FN.APPLICATION  = 'F.':CONTROL.LIST<1,1>
        F.APPLICATION = ''
        CALL OPF(FN.APPLICATION,F.APPLICATION)
        CALL F.DELETE(FN.APPLICATION,Y.PURGE.ID)
    END
RETURN
END
*----------End of Program--------------------------------------------------------------------
