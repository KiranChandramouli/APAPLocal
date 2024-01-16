* @ValidationCode : MjotNDI4Mjk4OTE4OlVURi04OjE2ODk3NDk2NTc2MzM6SVRTUzotMTotMToyOTI6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:17
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 292
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.UPDATE.OPENING.DATE
*------------------------------------------------------------------------------------*
* Technical report:                                                                  *
* -----------------                                                                  *
* Company Name   : APAP                                                              *
* Program Name   : LAPAP.UPDATE.OPENING.DATE                                         *
* Date           : 2017-09-09                                                        *
* Author         : RichardHC                                                         *
* Item ID        : CN007111                                                          *
*------------------------------------------------------------------------------------*
* Description :                                                                      *
* ------------                                                                       *
* This program allow modify the opening dates of the saving accounts                 *
*------------------------------------------------------------------------------------*
* Modification History :                                                             *
* ----------------------                                                             *
* Date           Author            Modification Description                          *
* -------------  -----------       ---------------------------                       *
* 14-07-2023    Conversion Tool     R22 Auto Conversion     BP is removed in insert file
* 17-07-2023    Narmadha V          R22 Manual Conversion   No Changes                                                                                *
*------------------------------------------------------------------------------------*
* Content summary :                                                                  *
* -----------------                                                                  *
* Table name     : ST.LAPAP.UPDATE.OPENING.DATE                                      *
* Auto Increment : LAPAP.UPDATE.OPENING.DATE                                         *
* Views/versions : ST.LAPAP.UPDATE.OPENING.DATE,INPUT/,DETAILS                       *
* EB record      : LAPAP.UPDATE.OPENING.DATE/LAPAP.UPDATE.OPENING.DATE.VAL           *
* Routines       : LAPAP.UPDATE.OPENING.DATE/LAPAP.UPDATE.OPENING.DATE.VAL           *
*------------------------------------------------------------------------------------*

*Importing the neccessary libraries and tables.
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ST.LAPAP.UPDATE.OPENING.DATE ;*R22 Auto Conversion
    $INSERT I_F.ACCOUNT


*Capturing data from browser layer and assigning those values to beside variables.
    VAR.ACC1 = R.NEW(ST.LAP14.ACCOUNT.NUMBER)
    VAR.ACC2 = R.NEW(ST.LAP14.OPENING.DATE)

*Declaring the below variables and assigning the corresponding table to use and default path.
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""

*Opening ACCOUNT table from memory (default path).
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

*Defining and reading R.ACCOUNT variable from F.ACCOUNT and getting the values in VAR.ACC1.
    ERR.ACCOUNT = ''; R.ACCOUNT = ''
*    CALL F.READ(FN.ACCOUNT,VAR.ACC1,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    CALL F.READU(FN.ACCOUNT,VAR.ACC1,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT,'');* R22 UTILITY AUTO CONVERSION

*Searching through this ResultSetArray the field between this signs <> and re-assigning the,
*second value received from browser.
    R.ACCOUNT<AC.OPENING.DATE> = VAR.ACC2

*Saving in memory the new changes and committing the same.
    CALL F.WRITE(FN.ACCOUNT,VAR.ACC1,R.ACCOUNT)
*FYE: Dont use this method in any version routine"
*CALL JOURNAL.UPDATE('')


RETURN

END
