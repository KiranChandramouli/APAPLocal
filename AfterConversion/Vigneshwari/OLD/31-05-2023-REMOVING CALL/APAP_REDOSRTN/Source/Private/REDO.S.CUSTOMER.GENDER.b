* @ValidationCode : MjotMTg0NTkzNjQ4NDpDcDEyNTI6MTY4MjQxNTEzOTM2NzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 15:02:19
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
SUBROUTINE REDO.S.CUSTOMER.GENDER(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.S.CUSTOMER.GENDER
*---------------------------------------------------------------------------------
*DESCRIPTION       : This program is used to get the gender values
*Modification history
*Date                Who               Reference                  Description
*06-04-2023      conversion tool     R22 Auto code conversion     FM TO @FM
*06-04-2023      Mohanraj R          R22 Manual code conversion   No changes

* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_REDO.DEAL.SLIP.COMMON
    GOSUB PROCESS
RETURN
*********
PROCESS:
*********
* Y.OUT = VAR.GENDER
    VIRTUAL.TAB.ID='GENDER'     ;*EB.LOOKUP ID
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
    CNT.VALUES = DCOUNT( VIRTUAL.TAB.ID,@FM)
    Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>       ;* EB.LOOKUP VALUES
    Y.LOOKUP.DESC=VIRTUAL.TAB.ID<CNT.VALUES>        ;* EB.LOOKUP DESCRIPTION
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC
    LOCATE VAR.GENDER IN Y.LOOKUP.LIST SETTING POS1 THEN
        VAR.USER.LANG = R.USER<EB.USE.LANGUAGE>       ;* Get the values based on user language
        Y.OUT = Y.LOOKUP.DESC<POS1,VAR.USER.LANG>
        IF NOT(Y.OUT) THEN
            Y.OUT=Y.LOOKUP.DESC<POS1,1>
        END
    END ELSE
        Y.OUT = ''
    END

RETURN
END
