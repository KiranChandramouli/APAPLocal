SUBROUTINE REDO.B.UPD.LAST.PRICE.LOAD
*-----------------------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed by : Temenos Application Management
* Program Name : REDO.B.UPD.LAST.PRICE.LOAD
* Program Type : BATCH JOB (Multithreaded routine)
*-----------------------------------------------------------------------------------------------
* Description : This is the Load routine in which we will opens all the necesseary files
*
* In Parameter : --na--
* Out Parameter : --na--
* ODR Number : ODR-2010-07-0083
*--------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*
* 15.11.2010 Krishna Murthy T.S SC006 INITIAL CREATION
*
*-------------------------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.PRICE.TYPE
    $INSERT I_REDO.B.UPD.LAST.PRICE.COMMON

    CALL GET.LOC.REF('SECURITY.MASTER','L.SC.TRN.YIELD',Y.TRN.LOC.POS)


    FN.PRICE.TYPE = 'F.PRICE.TYPE'
    F.PRICE.TYPE = ''
    R.PRICE.TYPE = ''
    Y.PT.ERR = ''
    CALL OPF(FN.PRICE.TYPE,F.PRICE.TYPE)

    FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
    F.SECURITY.MASTER = ''
    R.SECURITY.MASTER = ''
    Y.SM.ERR = ''
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)

RETURN
END
