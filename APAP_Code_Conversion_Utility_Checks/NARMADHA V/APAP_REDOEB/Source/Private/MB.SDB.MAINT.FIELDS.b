* @ValidationCode : MjotMjkyOTQwMzk1OkNwMTI1MjoxNjgxMzg0NDM1MTc0OklUU1M6LTE6LTE6LTIyOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 16:43:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -22
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.SDB.MAINT.FIELDS
*----------------------------------------------------------------------------
*** FIELD definitions FOR TEMPLATE
*!
* @author kbrindha@temenos.com
* @stereotype fields
* @uses C_METHODS
* @uses C_PROPERTIES
* @package infra.eb
*-----------------------------------------------------------------------------
* Revision History:
*------------------
* Date               who           Reference            Description
* 05/02/2009      K.BRINDHA                        Changed to R07 Template
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
* Modification History :
* dd/mm/yyy    - CD_REFERENCE - author
*              Description of modification. Why, what and who.
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_METHODS.AND.PROPERTIES

    GOSUB INITIALISE
    GOSUB DEFINE.FIELDS
RETURN

*** </region>
*-----------------------------------------------------------------------------
DEFINE.FIELDS:
    ID.F = 'SDB.ACTION' ; ID.N = '2.2' ;ID.T = '' ;
    Z = 0
    Z +=1 ; F(Z) = 'XX.DESCRIPTION' ; N(Z) = '65.2' ; T(Z) = 'A' ;
    Z+=1 ; F(Z) = "XX.LOCAL.REF" ; N(Z) = "35" ; T(Z) = ""
    Z +=1 ; F(Z) = 'RESERVED.10' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z +=1 ; F(Z) = 'RESERVED.9' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z +=1 ; F(Z) = 'RESERVED.8' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z +=1 ; F(Z) = 'RESERVED.7' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z +=1 ; F(Z) = 'RESERVED.6' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z +=1 ; F(Z) = 'RESERVED.5' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z +=1 ; F(Z) = 'RESERVED.4' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z +=1 ; F(Z) = 'RESERVED.3' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z +=1 ; F(Z) = 'RESERVED.2' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z +=1 ; F(Z) = 'RESERVED.1' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z+=1 ; F(Z) = "XX.OVERRIDE" ; N(Z) = "35" ; T(Z) = "A" ; T(Z)<3>='NOINPUT'
*-----------------------------------------------------------------------------
    V = Z + 9
RETURN
*-----------------------------------------------------------------------------
*** <region name= Initialise>
*** <desc>Create virtual tables and define check files</desc>
INITIALISE:
    MAT F = "" ; MAT N = "" ; MAT T = ""
    MAT CHECKFILE = "" ; MAT CONCATFILE = ""
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""
* TODO define common checkfile field enrichments
*-----------------------------------------------------------------------------
* An example of how to use the EB.LOOKUP virtual tables
* TODO Define virtual tables
    VIRTUAL.TABLE.LIST = ''
RETURN
*** </region>
*-----------------------------------------------------------------------------
END
