* @ValidationCode : MjotMTU2Njk0MTEzMjpDcDEyNTI6MTY4NDQwOTY2MDcxODpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 May 2023 17:04:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.V.VAL.DEB.AC.OUR.REF
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.DEB.AC.OUR.REF
*---------------------------------------------------------------------------------

*DESCRIPTION       : This routine used to default the value to OUR.REFERENCE field of Teller
*                    from TELLER.DEFAULT.
*
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 19-SEP-2011        Marimuthu S    PACS00121130       Initial Creation
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.DEFAULT

MAIN:

    GOSUB PROCESS
    GOSUB PGM.END

PROCESS:

    FN.TELLER.DEFAULT = 'F.TELLER.DEFAULT'
    F.TELLER.DEFAULT = ''
    CALL OPF(FN.TELLER.DEFAULT,F.TELLER.DEFAULT)

    Y.CR.AC = COMI
    SEL.CMD = 'SELECT ':FN.TELLER.DEFAULT:' WITH @ID LIKE ':Y.CR.AC:'...'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    R.NEW(TT.TE.OUR.REFERENCE) = SEL.LIST

RETURN

PGM.END:

END
