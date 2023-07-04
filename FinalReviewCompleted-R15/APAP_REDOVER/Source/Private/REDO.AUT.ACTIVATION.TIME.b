* @ValidationCode : MjotMTkwNTU0MDcyODpDcDEyNTI6MTY4MjQxMjMyNDY2NTpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUT.ACTIVATION.TIME
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: SWAMINATHAN
* PROGRAM NAME: REDO.AUT.ACTIVATION.TIME
* ODR NO      : ODR-2010-03-0400
*----------------------------------------------------------------------
*DESCRIPTION: This routine is authorisation routine to update time
* LATAM.CARD.ORDER,REDO.ACTIVATION
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE                 WHO                    REFERENCE                      DESCRIPTION
*9.03.2011       Swaminathan              ODR-2010-03-0400                 INITIAL CREATION
*1 JUL 2011       KAVITHA                 ODR-2010-03-0400                PACS00082441 FIX
* 04-04-2023      Conversion Tool       R22 Auto Code Conversion             No Changes
*04-04-2023       Samaran T                Manual R22 Code Conversion        No Changes
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.LATAM.CARD.ORDER

    FN.LATAM.CARD.ORDER = 'F.LATAM.CARD.ORDER'
    F.LATAM.CARD.ORDER = ''
    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)


    Y.TIME = OCONV(TIME(),"MTS")
*PACS00082441 -S
*    Y.DATE = OCONV(DATE(),"D2")
    Y.DATE = TODAY
*PACS00082441 -E

    IF R.NEW(CARD.IS.CARD.STATUS) EQ '94' OR R.NEW(CARD.IS.CARD.STATUS) EQ '50' THEN
        R.NEW(CARD.IS.ACTIVE.DATE) = Y.DATE
        R.NEW(CARD.IS.ACTIVE.TIME) = Y.TIME
    END
RETURN
END
