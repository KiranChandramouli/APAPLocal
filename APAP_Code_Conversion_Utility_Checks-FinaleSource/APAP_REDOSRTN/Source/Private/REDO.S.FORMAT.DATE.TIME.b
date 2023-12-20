* @ValidationCode : MjotOTU4NzM0NjgyOkNwMTI1MjoxNjgyNDE1MTQ1MzI5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 15:02:25
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
$PACKAGE APAP.REDOSRTN
SUBROUTINE REDO.S.FORMAT.DATE.TIME(SYS.DATE.TIME)

*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION : This routine is attached in DEAL.SLIP.FORMAT to format date and time
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : KAVITHA
* PROGRAM NAME : REDO.S.FORMAT.DATE.TIME
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 8-Apr-2011       S KAVITHA           ODR-2010-03-0400    INITIAL CREATION
*Modification history
*Date                Who               Reference                  Description
*10-04-2023      conversion tool     R22 Auto code conversion     No changes
*10-04-2023      Mohanraj R          R22 Manual code conversion   No changes

* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    TEMPTIME = SYS.DATE.TIME[7,4]
    TEMPTIME = TEMPTIME[1,2]:":":TEMPTIME[3,2]

    CHECK.DATE = SYS.DATE.TIME[1,6]
    CHECK.DATE = ICONV(CHECK.DATE,"D2")
    SYS.DATE=OCONV(CHECK.DATE,"D4")

    SYS.DATE.TIME = SYS.DATE

RETURN
