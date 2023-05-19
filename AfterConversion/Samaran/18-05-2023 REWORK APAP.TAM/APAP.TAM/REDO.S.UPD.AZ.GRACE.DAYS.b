* @ValidationCode : MjotMjY5MTU3OTQ5OkNwMTI1MjoxNjg0NDEyODQ3MjkyOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 May 2023 17:57:27
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
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM
*-----------------------------------------------------------------------------
SUBROUTINE REDO.S.UPD.AZ.GRACE.DAYS
* Correction routine to update the field L.AZ.GR.END.DAT and L.AZ.GRACE.DAYS
* PACS00200287

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT


    GOSUB INIT
    GOSUB PROCESS

    CALL JOURNAL.UPDATE('')

RETURN

******
INIT:
******
*Initialise all the variable
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    APPL.ARRAY = 'AZ.ACCOUNT'
    FLD.ARRAY  = 'L.AZ.GR.END.DAT':@VM:'L.AZ.GRACE.DAYS' ;*R22 AUTO CONVERSION
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.AZ.GR.END.DAT = FLD.POS<1,1>
    LOC.L.AZ.GRACE.DAYS = FLD.POS<1,2>

    MATURITY.DATE = ''
RETURN
*********
PROCESS:
*********
* Main process to select all the AZ.ACCOUNT
    SEL.CMD = "SELECT ":FN.AZ.ACCOUNT:" WITH L.AZ.GR.END.DAT EQ '' OR L.AZ.GRACE.DAYS EQ '' "
    SEL.LIST = ''

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)

    LOOP
        REMOVE Y.AZ.ID FROM SEL.LIST SETTING POS
    WHILE Y.AZ.ID:POS
        R.AZ = ''
        CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ,F.AZ.ACCOUNT,AZ.ERR)
        IF R.AZ THEN
            GRACE.DAYS = '7'
            NO.OF.DAYS = '+':GRACE.DAYS:'W'
            MATURITY.DATE = R.AZ<AZ.MATURITY.DATE>
            IF MATURITY.DATE THEN
                GOSUB UPD.FIELDS
            END
        END
    REPEAT
RETURN
*-------------------------------------------------
UPD.FIELDS:
*------------------------------------------------
    CALL CDT('',MATURITY.DATE,NO.OF.DAYS)
    R.AZ<AZ.LOCAL.REF,LOC.L.AZ.GRACE.DAYS> = GRACE.DAYS
    R.AZ<AZ.LOCAL.REF,LOC.L.AZ.GR.END.DAT> = MATURITY.DATE
    CALL F.WRITE(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ)
*  CALL REDO.AZ.WRITE.TRACE("REDO.S.UPD.AZ.GRACE.DAYS",Y.AZ.ID)
RETURN
*-------------------------------
END
