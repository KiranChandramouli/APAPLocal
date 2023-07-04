* @ValidationCode : MjotMTUxNDk5OTgyMzpDcDEyNTI6MTY4MjQxMjMyNjg2NDpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:26
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
SUBROUTINE REDO.AUT.REV.FT.ID
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.AUT.REV.FT.ID
* ODR NUMBER    : HD1052244
*-------------------------------------------------------------------------------
* Description   : This is auth routine will be attached to the version FT,CHQ.TAX
* In parameter  : none
* out parameter : none
*-------------------------------------------------------------------------------
* Modification History :
*-------------------------------------------------------------------------------
*   DATE             WHO                REFERENCE                      DESCRIPTION
* 21-01-2011      MARIMUTHU S            HD1052244                    Initial Creation
*04-04-2023        Conversion Tool       R22 Auto Code conversion      No Changes
*04-04-2023            Samaran T         Manual R22 Code Conversion    No Changes
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.TEMP.VERSION.IDS
*-------------------------------------------------------------------------------
MAIN:
*-------------------------------------------------------------------------------
    FN.REDO.TEMP.VERSION.IDS = 'F.REDO.TEMP.VERSION.IDS'
    F.REDO.TEMP.VERSION.IDS = ''
    CALL OPF(FN.REDO.TEMP.VERSION.IDS,F.REDO.TEMP.VERSION.IDS)

    SEL.CMD = 'SELECT ':FN.REDO.TEMP.VERSION.IDS:' WITH REV.TXN.ID EQ ':ID.NEW
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

    CALL F.READ(FN.REDO.TEMP.VERSION.IDS,SEL.LIST,R.REC.TEMP,F.REDO.TEMP.VERSION.IDS,TEMP.ERR)
    Y.REV.IDS = R.REC.TEMP<REDO.TEM.REV.TXN.ID>
    Y.REV.DATES = R.REC.TEMP<REDO.TEM.REV.TXN.DATE>

    LOCATE ID.NEW IN Y.REV.IDS<1,1> SETTING POS THEN
        DEL Y.REV.IDS<1,POS>
        DEL Y.REV.DATES<1,POS>
        R.REC.TEMP<REDO.TEM.REV.TXN.ID> = Y.REV.IDS
        R.REC.TEMP<REDO.TEM.REV.TXN.DATE> = Y.REV.DATES

        CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,SEL.LIST,R.REC.TEMP)
    END

RETURN
*-------------------------------------------------------------------------------
END
