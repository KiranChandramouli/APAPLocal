* @ValidationCode : MjozNTQzNzEyNzk6Q3AxMjUyOjE2ODQ4NTQ0MDAxODE6SVRTUzotMTotMToyMDA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
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
* Date                   who                   Reference              
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - NO CHANGES
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
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
