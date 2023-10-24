* @ValidationCode : MjoyOTExMjU3OTQ6Q3AxMjUyOjE2ODE5MDU2ODA2Nzk6SVRTUzotMTotMToxNzY6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 17:31:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 176
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.SECURITY.TERM(Y.RET)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Arulprakasam P
* PROGRAM NAME: REDO.DS.SECURITY.TERM
* ODR NO      : ODR-2010-07-0082
*----------------------------------------------------------------------
*DESCRIPTION: This routine is attched in DEAL.SLIP.FORMAT 'REDO.BUS.SELL'
* to get the details of the Product selected for LETTER

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*28-Mar-11      Pradeep S     PACS00051213      Rounded with out decimals
*16-JUN-11      RIYAS         PACS00074324      CHECK FOR CDD
*26-JUL-11      Pradeep S     PACS00091606      Security term 0 not considered
*05-FEB-13      Pradeep S     PACS00247754      Mapping details changed. Base defaulted to 365.
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SECURITY.MASTER

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

INIT:
*****
    FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
    F.SECURITY.MASTER = ''

RETURN

OPENFILES:
**********
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)
RETURN

PROCESS:
********

    SEC.TRADE.ID = Y.RET
    Y.RET = ''
    SEC.CODE.ID = R.NEW(SC.SBS.SECURITY.CODE)
    MATURITY.DATE = R.NEW(SC.SBS.MATURITY.DATE)
    ISS.DATE = R.NEW(SC.SBS.ISSUE.DATE)

    CALL F.READ(FN.SECURITY.MASTER,SEC.CODE.ID,R.SECURITY.MASTER,F.SECURITY.MASTER,SECURITY.MASTER.ERR)
    INT.DAY.BASIS = R.SECURITY.MASTER<SC.SCM.INTEREST.DAY.BASIS>
    BASE = FIELD(INT.DAY.BASIS,'/',2)
    NOF.DAYS = "C"
*PACS00074324-S
    IF ISS.DATE AND MATURITY.DATE THEN
        CALL CDD ("",ISS.DATE,MATURITY.DATE,NOF.DAYS)
    END
*PACS00074324-E
    DATE.DIFF = ABS(NOF.DAYS)
    SECURITY.TERM.VAL = DATE.DIFF / 365   ;* PACS00247754 - S/E

    SECURITY.TERM.VAL = FIELDS(SECURITY.TERM.VAL,".",1)       ;*PACS00051213 - S/E

*PACS00091606 - S
    IF SECURITY.TERM.VAL GE '1' THEN
        Y.RET = SECURITY.TERM.VAL
    END ELSE
        Y.RET = ''
    END
*PACS00091606 - E

RETURN

END
